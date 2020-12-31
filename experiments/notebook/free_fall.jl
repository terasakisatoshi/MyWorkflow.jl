# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.8.0
#   kernelspec:
#     display_name: Julia 1.5.3
#     language: julia
#     name: julia-1.5
# ---

using DifferentialEquations
using Plots

# +
function freefall(du,u,p,t)
    g = p[1]
    du[1] = u[2]
    du[2] = -g
end

x0 = 10.
v0 = 4.
g = 9.8
u0 = [x0; v0]
tspan = (0.0, 1.)
p = [g] # 重力加速度
prob = ODEProblem(freefall, u0, tspan, p)
sol = solve(prob);
# -

p = plot(sol, vars=(1))
plot!(
    t -> -0.5 * g * t^2 + v0*t + x0, 
    xlims=tspan,
    linestyle=:dash,
    size=(1000, 1000),
)
