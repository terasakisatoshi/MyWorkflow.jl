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
#     display_name: Julia 1.4.0
#     language: julia
#     name: julia-1.4
# ---

using Plots
using ForwardDiff
using Combinatorics

# # Generate 1 soliton

# +
v=1.
c=3.
θ = - 2c/√v

function u(x,t)
    v/2 * (sech(√v / 2 * (x-v*t-θ)))^2
end

# +
using Plots 

anim = @animate for t in 0.:0.1:10
    x=collect(-10:0.01:10)
    y=u.(x,t)
    plot(x,y,ylim=[0,1.])
end
# -

gif(anim)

# # Generate 2 soliton

# +
p = [1.,2.]
θ = [0, 1]
function τ(x,t)
    η=[
        p[1]*x - p[1]^3 * t - θ[1],
        p[2]*x - p[2]^3 * t - θ[2]
    ]
    A12 = ((p[1]-p[2])/(p[1]+p[2]))^2
    return 1 + exp(η[1])+exp(η[2]) + A12*exp(η[1]+η[2]) 
end


logτ(x,t)=log(τ(x,t))
logτ(xt) = logτ(xt[1], xt[2])
hessian = xt -> ForwardDiff.hessian(logτ,xt)
u(x,t)=hessian([x,t])[1]
anim = @animate for t in 0:0.05:10
    x=-10:0.1:10
    y=u.(x,t)
    plot(x,y,ylim=[0,3.])
end

gif(anim)
# -

# # n-soliton n =3

# +
θ = [0.0,5.0,-15.0]
p = [1.5,2.0,2.5]
N = length(p)

A = zeros(N,N)
for (i, j) in combinations(1:N,2)
    A[i,j] = ((p[i]-p[j])/(p[i]+p[j]))^2 |> log
end

function τ(x,t)
    η = @. p*x - p^3*t - θ
    ret = 0.
    for μ in Iterators.product(repeat([[0,1]],N)...)
        s1 = sum(μ .* η)
        s2 = 0.
        for (i,j) in combinations(1:N,2)
            s2= μ[i]*μ[j]*A[i,j]
        end
        ret += exp(s1 + s2)
    end
    ret
end

logτ(x,t)=log(τ(x,t))
logτ(xt) = logτ(xt[1], xt[2])
hessian = xt -> ForwardDiff.hessian(logτ,xt)
u(x,t)=hessian([x,t])[1]
anim = @animate for t in 0:0.05:10
    x=-10:0.1:10
    y=u.(x,t)
    plot(x,y,ylim=[0,3.],label="3-soliton")
end

gif(anim)
# -

# # Reference
#
# - 箱玉系の数理
