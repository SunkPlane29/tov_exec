using TOV
using CSV
using DataFrames
using Interpolations
using Plots

function remove_negative_slopes(eos::DataFrame)::DataFrame
    new_eos = DataFrame()
    new_eos.p = Vector{Float64}()
    new_eos.ϵ = Vector{Float64}()

    highest = 0.0
    for (i, p) in enumerate(eos.p)
        if p > highest
            highest = p
            append!(new_eos.p, p)
            append!(new_eos.ϵ, eos.ϵ[i])
        end
    end

    return new_eos
end

compose = ["T", "n_b", "Y_q", "p", "ϵ"]
reduced = ["p", "ϵ"]

function main(header::Vector{String} = compose)
    file = dat2csv("eos/eos.table")
 
    eos = CSV.File(file, header = header) |> DataFrame

    eos = remove_negative_slopes(eos)

    g = plot(eos.ϵ, eos.p, label = false, xaxis = "ϵ (MeV/fm³)", yaxis = "p (MeV/fm³)", show = false)
    savefig(g, "eosplot.png")

    pressure = eos.p .* MEVFM3_TO_PRESSURE_UNIT
    energy_density = eos.ϵ .* MEVFM3_TO_PRESSURE_UNIT

    eos_interp = linear_interpolation(pressure, energy_density)
    eos(p) = eos_interp(p)

    curve = solve_mrdiagram(pressure[1], last(pressure), eos, stepsize = 1*SI_TO_LENGTH_UNIT, nstars = 1000)

    radius = []
    mass = []

    #FIXME: for some reason the first radius and mass will be a really small number?
    for (i, r) in enumerate(curve.xvalues)
        if i ≢ 1 && r < 17
            append!(radius, r)
            append!(mass, curve.yvalues[i])
        end
    end

    p = plot(radius, mass, label = false, xaxis = "radius (km)", yaxis = raw"mass (M$_{\odot}$)", show = false)

    savefig(p, "mrdiagram.png")
end
