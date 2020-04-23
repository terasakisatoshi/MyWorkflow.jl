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

# +
using LinearAlgebra

using Plots
using SymPy
using LaTeXStrings
# -

# # 回転行列

# +
Rx(θ) = [
    1.   0.        0
    0.  cos(θ) -sin(θ)
    0.  sin(θ)  cos(θ)
]

Ry(θ) = [
    cos(θ)  0. sin(θ)
     0.     1.   0. 
    -sin(θ) 0. cos(θ)
]

Rz(θ) = [
    cos(θ) -sin(θ) 0
    sin(θ) cos(θ)  0
    0.          0. 1
]

# -

# # 3D 回転行列 のオイラー角表示
#
# - ３次元の回転は $SO(3)$ の要素として特徴付けられる. $R\in SO(3)$ とする.
# $\mathbb{e}_1,\mathbb{e}_2,\mathbb{e}_3$ を標準基底とする. このとき
# $u_i = R\mathbb{e}_i$ を回転 $R$ による $\mathbb{e}_i$ の作用の像とする．
# - $u_i$ はランダムに与えた一次独立なベクトルからシュミットの直交化法により生成することができる.

# generate orthogonal basis
a1,a2,a3 = rand(3),rand(3),rand(3)
u1 = normalize(a1)
u2 = normalize(a2 .- dot(a2, u1) .* u1)
u3 = normalize(a3 .- dot(a3, u2) .* u2 .- dot(a3, u1) .* u1)

# - ただし得られるベクトルがなす平行6面体の符号つき体積が正であることを保証する必要がある．$\det(u1,u2,u3)$ を計算してその値が負であれば適当なベクトルの符号をマイナスにすることで体積の符号を押し付けることができる．

if det(hcat(u1,u2,u3)) < 0
    u1 = -u1
end

# +
@show dot(u1,u1)
@show dot(u1,u2) 
@show dot(u1,u3) 

@show dot(u2,u1)
@show dot(u2,u2)
@show dot(u2,u3)

@show dot(u3,u1)
@show dot(u3,u2)
@show dot(u3,u3)
# -

# $u_i = R\mathbb{e}_i$ となる $R$ を求めたい. $z$ 軸周りの回転をすることで $u_3$ を $zx$ 平面上に移動させることができる. $u_3$ の終点を通る $xy$ 平面に並行な平面上において$u_3$ の終点が$x$ 軸となす角度を $\varphi$ とすると $z$ 軸を中心に $-\varphi$ だけ回転すれば良い

u3_x = u3[1]
u3_y = u3[2]
φ = atan(u3_y, u3_x)
v1 = Rz(-φ) * u1
v2 = Rz(-φ) * u2
v3 = Rz(-φ) * u3

# 回転して得られる $u_i$ を $v_i$ とおく. 今度は $v_3$ を $z$ 軸に重なるように回転する. $z$ 軸となす角度を $\theta$ とすれば $y$ 軸を中心に $-\theta$ だけ移動させれば良い.

v3_x, v3_z = v3[1], v3[3]
θ = atan(v3_x, v3_z)
w1 = Ry(-θ) * v1
w2 = Ry(-θ) * v2
w3 = Ry(-θ) * v3

# 回転して得られる $v_i$ を $w_i$ とおく. $w_3$ が $z$ 軸にあるので $w_1, w_2$ は xy 平面上にある. 実際下記を実行すると $z$ 座標の値は非常に小さい値をえる.

println("w1=$w1")
println("w2=$w2")

# $w_1$ と $x$ 軸のなす角度を $\psi$ とする. $w_1$ を $x$ 軸に重ねるには $-\psi$ だけ回転させれば良い.

# +
w1_x, w1_y = w1[1], w1[2]
ψ = atan(w1_y, w1_x)
x = Rz(-ψ) * w1
y = Rz(-ψ) * w2
z = Rz(-ψ) * w3

println("x=$x")
println("y=$y")
println("z=$z")
# -

# # 動きの可視化

# generate orthogonal basis
a1, a2, a3 = rand(3), rand(3), rand(3)
u1 = normalize(a1)
u2 = normalize(a2 .- dot(a2, u1) .* u1)
u3 = normalize(a3 .- dot(a3, u2) .* u2 .- dot(a3, u1) .* u1)
if det(hcat(u1,u2,u3)) < 0
    u1 = -u1
end

# +
p = plot3d(xlabel=L"x",ylabel=L"y",zlabel=L"z",aspect_ratio=:equal,xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],title=L"u",camera=(80,60))
plot3d!(p, [0,u1[1]],[0,u1[2]],[0,u1[3]],legend=false,color=:red)
plot3d!(p, [0,u2[1]],[0,u2[2]],[0,u2[3]],legend=false,color=:green)
plot3d!(p, [0,u3[1]],[0,u3[2]],[0,u3[3]],legend=false,color=:blue)

pu = p

u3_x = u3[1]
u3_y = u3[2]
φ = atan(u3_y, u3_x)
v1 = Rz(-φ) * u1
v2 = Rz(-φ) * u2
v3 = Rz(-φ) * u3

p = plot3d(xlabel=L"x",ylabel=L"y",zlabel=L"z",aspect_ratio=:equal,xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],title=L"v",camera=(80,60))
plot3d!(p, [0,v1[1]],[0,v1[2]],[0,v1[3]],legend=false,color=:red)
plot3d!(p, [0,v2[1]],[0,v2[2]],[0,v2[3]],legend=false,color=:green)
plot3d!(p, [0,v3[1]],[0,v3[2]],[0,v3[3]],legend=false,color=:blue)

pv = p

v3_x, v3_z = v3[1], v3[3]
θ = atan(v3_x, v3_z)
w1 = Ry(-θ) * v1
w2 = Ry(-θ) * v2
w3 = Ry(-θ) * v3

p = plot3d(xlabel=L"x",ylabel=L"y",zlabel=L"z",aspect_ratio=:equal,xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],title=L"w",camera=(80,60))
plot3d!(p, [0,w1[1]],[0,w1[2]],[0,w1[3]],legend=false,color=:red)
plot3d!(p, [0,w2[1]],[0,w2[2]],[0,w2[3]],legend=false,color=:green)
plot3d!(p, [0,w3[1]],[0,w3[2]],[0,w3[3]],legend=false,color=:blue)

pw = p

w1_x, w1_y = w1[1], w1[2]
ψ = atan(w1_y, w1_x)
x1 = Rz(-ψ) * w1
x2 = Rz(-ψ) * w2
x3 = Rz(-ψ) * w3

plot(pu,pv,pw,layout=(1,3)) |> display

p = plot3d(xlabel=L"x",ylabel=L"y",zlabel=L"z",aspect_ratio=:equal,xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],title=L"x",camera=(80,60))
plot3d!(p, [0,x1[1]],[0,x1[2]],[0,x1[3]],legend=false,color=:red)
plot3d!(p, [0,x2[1]],[0,x2[2]],[0,x2[3]],legend=false,color=:green)
plot3d!(p, [0,x3[1]],[0,x3[2]],[0,x3[3]],legend=false,color=:blue)

p |> display
# -

ps = []

# +
u3_x = u3[1]
u3_y = u3[2]
φ = atan(u3_y, u3_x)

for t in range(0,1,length=50)
    r = t*φ
    IJulia.clear_output(true)
    p = plot3d(
        xlabel=L"x",ylabel=L"y",zlabel=L"z",
        aspect_ratio=:equal,
        xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],
        camera=(80,60)
    )
    v1 = Rz(-r) * u1
    v2 = Rz(-r) * u2
    v3 = Rz(-r) * u3
    plot3d!(p, [0,v1[1]],[0,v1[2]],[0,v1[3]],legend=false,color=:red)
    plot3d!(p, [0,v2[1]],[0,v2[2]],[0,v2[3]],legend=false,color=:green)
    plot3d!(p, [0,v3[1]],[0,v3[2]],[0,v3[3]],legend=false,color=:blue)
    p|>display
    push!(ps, p)
end

v1 = Rz(-φ) * u1
v2 = Rz(-φ) * u2
v3 = Rz(-φ) * u3
@show v3

# +
v3_x, v3_z = v3[1], v3[3]
θ = atan(v3_x, v3_z)

for t in range(0,1,length=50)
    IJulia.clear_output(true)
    r = t*θ    
    p = plot3d(
        xlabel=L"x",ylabel=L"y",zlabel=L"z",
        aspect_ratio=:equal,
        xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],
        camera=(80,60)
    )
    w1 = Ry(-r) * v1
    w2 = Ry(-r) * v2
    w3 = Ry(-r) * v3
    plot3d!(p, [0,w1[1]],[0,w1[2]],[0,w1[3]],legend=false,color=:red)
    plot3d!(p, [0,w2[1]],[0,w2[2]],[0,w2[3]],legend=false,color=:green)
    plot3d!(p, [0,w3[1]],[0,w3[2]],[0,w3[3]],legend=false,color=:blue)
    push!(ps, p)
    p |> display
end

w1 = Ry(-θ) * v1
w2 = Ry(-θ) * v2
w3 = Ry(-θ) * v3

# +
w1_x, w1_y = w1[1], w1[2]
ψ = atan(w1_y, w1_x)

for t in range(0,1,length=50)
    IJulia.clear_output(true)
    r = t*ψ 
    p = plot3d(
        xlabel=L"x",ylabel=L"y",zlabel=L"z",
        aspect_ratio=:equal,
        xlim=[-3,3],ylim=[-3,3],zlim=[-3,3],
        camera=(80,60),
    )
    x1 = Rz(-r) * w1
    x2 = Rz(-r) * w2
    x3 = Rz(-r) * w3
    plot3d!(p, [0,x1[1]],[0,x1[2]],[0,x1[3]],legend=false,color=:red)
    plot3d!(p, [0,x2[1]],[0,x2[2]],[0,x2[3]],legend=false,color=:green)
    plot3d!(p, [0,x3[1]],[0,x3[2]],[0,x3[3]],legend=false,color=:blue)
    p |> display
    push!(ps, p)
end


x = Rz(-ψ) * w1
y = Rz(-ψ) * w2
z = Rz(-ψ) * w3
# -

# 以上をまとめると次のように動く

for p in ps IJulia.clear_output(true); plot(p)|>display end

# - 以上のようにして $R_z(-\psi)R_y(-\theta)R_z(-\varphi)u_i$ と変換することで回転像を標準基底に戻すことができた. ここで $R_i$ は $i(=x,y,z)$ 軸を周りとする回転を表す.
#
# - つまり回転 $R$ は $R=R_z(\varphi)R_y(\theta)R_z(\psi)$ というように回転行列の積に分解できる. この表示をオイラー角による表示と呼ぶ.

# # おまけ
#
# - 最初のベクトルの回転を $zx$ 平面ではなく $yz$ 平面に動かすとどうなるか. その場合は 
#
# - $(\varphi-\pi/2)$ だけZ軸で回転
# - $\theta$ だけX軸で回転
# - $xy$ 軸にフィットするように適当な $-\eta$ だけ $z$ 軸周りで回転させれば良い.
#
# そうすると $R_z(\varphi-\pi/2) R_x(-\theta) R_z(\eta)$ が求める形になる.
# 実は $\eta$ は $\psi+\pi/2$ を与えれば良い. 実際 $R(\eta)$ の式
#
# $R_z(\eta) = R_x(\theta) R_z(\pi/2-\varphi) R_z(\varphi) R_y(\theta) R_z(\psi)$ をSymPy.jl を使って解くことにする．

@vars φ θ ψ
Rx(θ) * Rz(PI/2-φ) * Rz(φ) * Ry(θ) * Rz(ψ) .|> simplify

# この式を眺めると $x$ 軸での回転の式に似ている $\eta = \psi + \pi/2$ とおけばそれを満たすことがわかる.
# 念のため検算しておく:

@vars φ θ ψ
r1 = Rz(φ-PI/2) * Rx(-θ) * Rz(ψ+PI/2)
r2 = Rz(φ) * Ry(θ) * Rz(ψ)
r2 - r1

# 良さそうである.
