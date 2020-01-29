# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.3.3
#   kernelspec:
#     display_name: Julia 1.3.1
#     language: julia
#     name: julia-1.3
# ---

print("Hello world")

using Plots

for t in 1:0.1:10
    IJulia.clear_output(true)
    plot(x-> sin(x+t)) |> display
end
