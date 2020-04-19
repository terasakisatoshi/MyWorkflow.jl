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

# # 情報幾何学のお勉強のぉと

# ## 導入
#
# $p$,$q$ を正の実数とする. $y=px^2$, $x=qy^2$ という $xy$ - 平面上の曲線を考える．この二つの曲線は原点ともう一つの点 $P=(x_0,y_0)$ と交わる．簡単な計算によってそれは $p$, $q$ を用いると $P = (x_0,y_0) = (p^{-2/3}q^{-1/3}, p^{-1/3}q^{-2/3})$ で与えられることがわかる．これをプログラミング言語 Julia を用いて確認する．

using Plots

using Interact

function vis_crosspoint(p::Float64,q::Float64)
    x = range(0,3,length=30) |> collect
    y = range(0,3,length=30) |> collect
    plot!(x,p*x.^2,color=:blue)
    plot!(q*y.^2,y,color=:orange)
    scatter!([p^(-2/3)*q^(-1/3)],[p^(-1/3)*q^(-2/3)])
end

# ## 試しに描画

plot(xlim=(0.,3.), ylim=(0.,3.), legend=:false)
vis_crosspoint(1.,2.4)

# ## Interact.jl で $p$ と $q$ を変動させた様子を描画

# +
p_slider = slider(0.001:0.1:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")

plot(xlim=(0.,3.), ylim=(0.,3.), legend=:false)
cross_pt = map(
    (p,q)->vis_crosspoint(p,q),
    map(observe,[p_slider,q_slider])...,
)

[p_slider,q_slider,cross_pt] .|> display
# -
# ## $q$ を固定して $p$ だけ動かす

# +
plot(xlim=(0.,3.), ylim=(0.,3.), legend=:false)
anim = @animate for p in range(0.1,1,length=10)
    p=vis_crosspoint(p,1.4)
    plot!(p)
end

gif(anim, "/tmp/anim_fps15.gif", fps = 3)
