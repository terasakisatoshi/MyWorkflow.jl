# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.6.0
#   kernelspec:
#     display_name: Julia 1.5.2
#     language: julia
#     name: julia-1.5
# ---

# # RCall Example

using RCall
using Plots

x = randn(10)

Plots.plot(x)
Plots.scatter!(x)

@rput x

R"plot(x, type='b')"
