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
#     name: julia-1.5
# ---

using Plots
using Statistics
using LinearAlgebra

# $N$ 個の sample $X_1,X_2,\dots, X_N \in \mathbb{R}^n$ が与えられているときにその性質をよく反映する部分空間を求めたい.
# 部分空間を求めるということはその空間を生成する正規直交基底を取れば良い. sample は平均がゼロベクトルになるように正規化されているとする.
#
# $$
# X=
# \begin{bmatrix}
# X_1\ X_2 \dots X_N
# \end{bmatrix}
# $$
#
# で定める行列 $X$ を定義する. これは縦ベクトルであるサンプルを横にN列並べて得られる行列である. $X$ を特異値分解(SVD)することで
#
# $$
#         X=U\Sigma V^\top
# $$
#
# のように記述できたとする. ただし $\Sigma$ は特異値 $\sigma_1,\dots,\sigma_{\mathrm{rank}(\Sigma)}$をの大きい順に並べた対角行列となっているとする.
# 部分空間の次元が $r$ であれば求めたい部分空間は $\sigma_1,\dots,\sigma_r$ に対応する左特異ベクトル $u_1,\dots,u_r$ であることが知られている.

# # Line Fitting

# +


f(x) = 2x + 1
N = 10
x = 2 .* rand(N) .- 1
plot(x, f.(x), label="ground truth")
y = f.(x) + 0.1 * randn(N)
scatter!(x, y, label="sample")
gx = mean(x)
gy = mean(y)

X = hcat(x .- gx, y .- gy)'
U, Σ, Vt = svd(X)
(u11, u21, u12, u22) = U

x = range(-1, 1, length=100)
y = @. -u12 * (x - gx) / u22 + gy
plot!(x, y, label="predict")

# -

# # Surface Fitting

# +
using Statistics
using Plots
using LinearAlgebra

f(x, y) = x + y
N = 50

plot(xlim=[-1, 1], ylim=[-1, 1])
x = range(-1.0, 1.0, length=30)
y = range(-1.0, 1.0, length=30)
plot!(x, y, f, st=:wireframe, label="ground truth")

x = 2 .* rand(N) .- 1
y = 2 .* rand(N) .- 1
z = f.(x, y) .+ 0.5 .* randn(N)


scatter!(x, y, z, label="sample")
gx = mean(x)
gy = mean(y)
gz = mean(z)

X = hcat(x .- gx, y .- gy, z .- gz)'
U, Σ, Vt = svd(X)
ux, uy, uz = U[:, 3]
x = range(-0.5, 0.5, length=30)
y = range(-0.5, 0.5, length=30)
pred(x, y) = -(ux * (x - gx) + uy * (y - gy)) / uz + gz
plot!(x, y, pred, st=:surface, alpha=0.5, label="predict")

