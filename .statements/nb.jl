# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.11.1
#   kernelspec:
#     display_name: Julia 1.6.1
#     language: julia
#     name: julia-1.6
# ---

using Plots

1+1

plot(sin)
plot!(cos)

# +
x = []
y = []

anim = @animate for θ in -π:0.1:π
    push!(x, cos(θ))
    push!(y, sin(θ))
    plot(x, y, xlim=[-1,1], ylim=[-1,1], aspect_ratio=:equal)
end

gif(anim)
