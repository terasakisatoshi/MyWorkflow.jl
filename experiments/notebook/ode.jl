# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.4.2
#   kernelspec:
#     display_name: Julia 1.4.1
#     language: julia
#     name: julia-1.4
# ---

# # Solving Scalar Equations
#
# - https://docs.sciml.ai/v5.0.0/tutorials/ode_example.html#Example-1-:-Solving-Scalar-Equations-1

# ## simple form

using DifferentialEquations
f(u,p,t) = 1.01*u
u0=1/2
tspan = (0.0,1.0)
prob = ODEProblem(f,u0,tspan)
sol = solve(prob,Tsit5(),reltol=1e-8,abstol=1e-8)
using Plots
plot(sol,linewidth=5,title="Solution to the linear ODE with a thick line",
     xaxis="Time (t)",yaxis="u(t) (in μm)",label="My Thick Line!") # legend=false
plot!(sol.t, t->0.5*exp(1.01t),lw=3,ls=:dash,label="True Solution!")

# ## a little generic form

# +
using DifferentialEquations

# function form and `du` argument is added
function f(du, u, p, t)
    du[1] = 1.01 * u[1]
end

u0 = [1 / 2] # 1/2 -> [1/2] scalar to arrays
tspan = (0.0, 1.0)
prob = ODEProblem(f, u0, tspan)
sol = solve(prob,Tsit5(),reltol=1e-8,abstol=1e-8)
using Plots
plot(sol,linewidth=5,title="Solution to the linear ODE with a thick line",
     xaxis="Time (t)",yaxis="u(t) (in μm)",label="My Thick Line!") # legend=false
plot!(sol.t, t->0.5*exp(1.01t),lw=3,ls=:dash,label="True Solution!")

# -

# # Lotka-Voltera equation
#
# - Code and other topics is taken from https://julialang.org/blog/2019/01/fluxdiffeq/#what_is_the_neural_ordinary_differential_equation_ode
#
# $$
# \begin{align}
# x' &= \alpha x + \beta xy \\
# y' &= -\delta y + \gamma xy    
# \end{align}
# $$

# +
using DifferentialEquations 

# define Differenial Equation
function lotka_volterra(du, u, p, t) 
    x, y = u 
    α, β, δ, γ = p 
    du[1] = α*x - β*x*y 
    du[2] = -δ*y + γ*x*y 
end 

# set initial
u0 = [1.0, 1.0] 

tspan = (0.0, 10.0) 
p = [1.5, 1.0, 4.0, 1.0]

# set ODE solver
prob = ODEProblem(lotka_volterra, u0, tspan, p)

sol = solve(prob) 
using Plots 
plot(sol)
