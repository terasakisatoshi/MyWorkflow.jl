# -*- coding: utf-8 -*-
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

# # Gradient descent (勾配法)
#
# 勾配法の練習として下記の簡単な設定のもとで勾配法を逐次適用することで目的関数の極値問題を解く際の点の動きを可視化する.
#
# $A$ を 2x2 の実対称行列とし, $f=f(x,y)$ を次で定める二変数関数とする.
#
# $$
# f(x,y) =  \begin{bmatrix}x & y\end{bmatrix} A \begin{bmatrix} x \\ y \end{bmatrix}
# $$
#
# このとき $f$ の勾配ベクトルは $\nabla f$ は 
#
# $$
# \nabla f= \begin{bmatrix} \frac{\partial f}{\partial x} \\ \frac{\partial f}{\partial y} \end{bmatrix} = A \begin{bmatrix} x \\ y \end{bmatrix}
# $$
#
# と書ける. 初期位置を $v_0\in\mathbb{R}^2$, 学習率を $\eta$ とすれば $i$ 番目のステップで得られる点は次のようになる.
#
# $$
# v_{i} = v_{i-1} - \eta \nabla f|_{(x,y)=v_{i-1}} \quad (i=1,2,\dots)
# $$

using Colors
using LinearAlgebra
using Plots

# +
A = [
    2.0  0.2
    0.2  1.0
]

f(v) =  dot(v, A, v)
f(x, y) = f([x, y])
∇f(v) = A * v
η = 0.05 # learning rate
# -

# ## 等高線の描画

x = range(-10, stop=10, length=50)
y = range(-10, stop=10, length=50)
p = contour(x, y, f)

# ## 勾配法を試す

# +
x = range(-5, stop=5, length=50)
y = range(-5, stop=5, length=50)
p = contour(x, y, f, levels=range(0, stop=100, step=3))

v = [-5., -5.] # initial point
for i in 1:100
    v .-= η .* ∇f(v)
    scatter!(
        p, [v[1]], [v[2]], 
        label=:none, color=:blue, msize=3,
    )
end

plot(p)
# -

# ## ランダムに点を配置しそれを初期値とする勾配法

# +
x = range(-5, stop=5, length=50)
y = range(-5, stop=5, length=50)
p = contour(x, y, f, levels=range(0, stop=100, step=3))
for _ in 1:10
    v = rand(range(-5, stop=5, step=0.01), 2)
    c =　RGB(rand(3)...)
    for _ in 1:30 # num steps
        v .-= η .* ∇f(v)
        scatter!(
            p, [v[1]], [v[2]], 
            label=:none, color=c, msize=3,
        )
    end
end

plot(p)
