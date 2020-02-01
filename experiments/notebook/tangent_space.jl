# -*- coding: utf-8 -*-
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

using Plots
using Distributions
using LinearAlgebra
using ForwardDiff

# +
struct Point{T<:Real}
    x::T
    y::T
end


Point(xy::Vector{T}) where {T} = Point{T}(T.(xy)...)

# +
struct Tp
    zfunc::Function
    v::Vector{Float64}
    w::Vector{Float64}
    p::Point{Float64}
    invA::Matrix{Float64}
end

function Tp(zfunc, p_xy)
    zfuncwrap(xy) = zfunc(xy...)
    g = xy -> ForwardDiff.gradient(zfuncwrap, xy)
    ∇g_x, ∇g_y = g(p_xy)

    v = [
        1.0
        0.0
        ∇g_x
    ]

    w = [
        0.0
        1.0
        ∇g_x
    ]

    v = normalize(v)
    w = normalize(w)

    A = [
        v[1] w[1]
        v[2] w[2]
    ]

    Tp(zfunc, v, w, Point(p_xy), inv(A))
end

function tangent_plane(tp::Tp, x, y)
    z_vec = [tp.v[3] tp.w[3]] * tp.invA * [x, y]
    z = z_vec[1] + tp.zfunc(tp.p.x, tp.p.y)
    return z
end
# -

d = MvNormal([0.5, 0.5], I(2))
zfunc(x, y) = pdf(d, [x, y])
tp = Tp(zfunc, [0.0, 0.0])

function visualize(tp::Tp; camera = (0, 30))
    tp_xs = range(tp.p.x - 0.5, tp.p.x + 0.5, length = 10)
    tp_ys = range(tp.p.y - 0.5, tp.p.y + 0.5, length = 10)
    xs = range(tp.p.x - 3.0, tp.p.x + 3.0, length = 20)
    ys = range(tp.p.y - 3.0, tp.p.y + 3.0, length = 20)
    p = plot()
    wireframe!(p, tp_xs, tp_ys, (x, y) -> tangent_plane(tp, x, y), camera = camera)
    surface!(p, xs, ys, (x, y) -> tp.zfunc(x, y), camera = camera)
    return p
end

@gif for θ in 1:180
    visualize(tp, camera = (θ, 30))
end
