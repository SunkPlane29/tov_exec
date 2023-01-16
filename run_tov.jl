include("main.jl")

if abspath(PROGRAM_FILE) == @__FILE__
    if length(ARGS) == 1
        s = Symbol(ARGS[1])
        @eval(header = $s)
        main(header)
    else
        main()
    end
end
