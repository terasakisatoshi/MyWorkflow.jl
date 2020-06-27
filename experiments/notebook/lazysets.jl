# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.5.0
#   kernelspec:
#     display_name: Julia 1.4.2
#     language: julia
#     name: julia-1.4
# ---

using LazySets
using LazySets.Approximations
using Plots

]st LazySets

hs1 = HalfSpace([-1.0, 1.0], 0.0)
hs2 = HalfSpace([1.,1.],0.)
hs3 = HalfSpace([0.,-1.],0.5)
p=plot(aspect_ratio=:equal,xlim=[-1,1])
plot!(p, hs1, color=:red)
plot!(p, hs2, color=:blue)
plot!(p, hs3, color=:green)

plot([hs1, hs2, hs3], aspect_ratio=:equal)

# +
p=plot(xlim=[-1,1],ylim=[-1,1],aspect_ratio=:equal)

ph = HPolyhedron([hs1, hs2, hs3])
P_as_polytope = convert(HPolytope, ph);
P_as_polytope |> plot!
