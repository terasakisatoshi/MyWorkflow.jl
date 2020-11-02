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

# # Convex hull

using LazySets
using Plots

points(N) = [randn(2) for i in 1:N]
v = points(30)
hull = convex_hull(v)
p = plot([Singleton(vi) for vi in v])
plot!(p, VPolygon(hull), alpha=0.2)
