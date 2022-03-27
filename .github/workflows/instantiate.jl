ENV["R_HOME"]="*"
using Pkg
Pkg.activate("@.")
Pkg.instantiate()
Pkg.precompile()
