# TOV exec

This is a somewhat utility program that can be used to solve the Tolman-Oppenheimer-Volkoff equations given a equation of state defined in a datafile (in fortran style).

## How to run

Requirements are:
- Having the julia programming language installed (if you are using a development container, it will be already installed)

If you wish to use CompOSE:
- GNU make utility (or any other make utility)
- gfortran compiler

You need to have a datafile containing the EOS in eos/eos.table (data in fortran format). #TODO: write something about the column format (issue about temperature, baryon number density and baryon charge fraction).

After having all of the requirements you can simply initialize the julia REPL with: `$ julia`. The TOV solving code uses all threads available if possible, so if you want to use all threads you need to initialize the REPL with: `$ julia --threads auto`, or if you want a specific number of threads: `$julia --threads NTHREADS`.

After initializing the REPL you need to initialize the environment pressing `]` and typing `activate .` and then `instantiate`. After this you need to backspace to enter the REPL normal mode.

Then include the `main.jl`file so just type: `include("main.jl")`.

And run the code with `main()`.

The workflow should be like, starting from bash:

```
$ julia --threads auto
julia>
(@v1.8) pkg> initialize .
(@v1.8) pkg> instantiate
julia>include("main.jl")
julia>main()
```