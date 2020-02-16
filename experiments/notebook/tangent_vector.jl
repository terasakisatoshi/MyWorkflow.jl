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

# # 曲線座標系での接ベクトルのお話
# ## 概要
#   - 「情報幾何学の基礎」の Example を Julia を介して理解しようという試みのノートです．
#   

# ## 必要な Julia のライブラリを導入

using Plots
using Interact
using ForwardDiff
using SymPy

# # 曲線座標系の導入
#
# - $p$, $q$ をゼロ以上の実数とし, 次で定まる二次曲線 $C_p$, $C_q$ を考える.
#
# $$
# \begin{equation}
# C_p: y=px^2,\quad C_q: x=qy^2 \label{pqcurve}
# \end{equation}
# $$
#
# - これは簡単な計算によって, 原点及び $P=P(p,q)=(p^{-2/3}q^{-1/3}, p^{-1/3}q^{-2/3})$ という交点を持つ. 

# ## 試しに描画してみる
#
# - $(z^1,z^2)$ を標準的な直交座標系とする二次元ユークリッド空間上に曲線 $C_p, C_q$ 及びその交点を描画してみよう．

# +
# P=P(p,q)=(φ¹(p,q),φ²(p,q))
φ¹(p::Real,q::Real) = p^(-2/3)*q^(-1/3)
φ²(p::Real,q::Real) = p^(-1/3)*q^(-2/3)


xlim=(0.,3.)
ylim=(0.,3.)

function vis_pqcurve(p, q)
    x = range(xlim...,length=30) |> collect
    y = range(ylim...,length=30) |> collect
    plot!(x,p*x.^2,color=:blue, label="C_p")
    plot!(q*y.^2,y,color=:orange, label="C_q")
    scatter!([φ¹(p,q)],[φ²(p,q)], label="P")
end

p₀, q₀=(1.,2.4) # 適当に定める.
plot(xlim=xlim,ylim=ylim,xlabel="z^1", ylabel="z^2")
vis_pqcurve(p₀, q₀)
# -
# ### 対話的操作で確認
#
# - せっかくなので $(p,q)$ を動かした時に $C_p$, $C_q$ がどのように振舞うかを確認する.

# +
p_slider = slider(0.001:0.1:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")


cross_pt = map(
    (p,q) -> begin 
            plot(xlim=xlim,ylim=ylim,xlabel="z¹", ylabel="z²")
            vis_pqcurve(p,q) 
    end,
    map(observe,[p_slider,q_slider])...,
)

[p_slider,q_slider,cross_pt] .|> display;
# -

# - slider を作成を動かすと曲線が変化する様子がわかる．そして対応する交点も変化する．

# ## 曲線による平面の点の特徴付け
#
# - このようにして二つの二次曲線 $C_p$, $C_q$ を与えると対応する(非自明な交点である) $P$ を与えることができる．
# - 逆に第一象限の点 $P=(z^1, z^2)$, $z^1>0,z^2>0$ が与えられたとき 
#
# $$
# \begin{equation}
# p = \frac{z^2}{(z^1)^2} ,\quad q = \frac{z^1}{(z^2)^2} \label{z2p}
# \end{equation}
# $$
#
# で与えられる $p$, $q$ から定まる $C_p$, $C_q$ の交点は $P$ になっている. 実際, $(\ref{z2p})$ は $x=z^1$, $y=z^2$ とおいたときに $(\ref{pqcurve})$ の解になっている.
#
# - さらに, 相異なる $(p,q)$ の組 $(p_1,q_1)$, $(p_2,q_2)$ に対して定まる $P(p_1,q_1)$, $P(p_2,q_2)$は相異なることも容易にわかる．

# ### 確認のため描画
#
# - 下記のコードは直交座標系を持つユークリッド空間の点 $(z^1,z^2)$ を動かした時に対応する $(p,q)$ の位置を描画してくれる.
# - 描画された $(p,q)$ に対応する $C_p$, $C_q$ から定まる $P$ は $(z^1,z^2)$ と一致する

# +
xlim=(0.,3.)
ylim=(0.,3.)

z1_slider = slider(0.001:0.1:3,label="z^1")
z2_slider = slider(0.001:0.1:3,label="z^2")

cross_pt = map(
    (z1,z2) -> begin 
        p, q = z2/z1^2, z1/z2^2 # (2) の実装
        plt1=plot(xlim=xlim,ylim=ylim,xlabel="p", ylabel="q",aspect_ratio=:equal)
        scatter!(plt1, [p],[q], label="(p,q)")
        plt2=plot(xlim=xlim,ylim=ylim,xlabel="z^1", ylabel="z^2",aspect_ratio=:equal)
        # ここで求めたp, q で定まる二次曲線 C_p, C_q の曲線を描画する．
        vis_pqcurve(p, q)
        # (z^1,z^2) の点を描画. vis_pqcurve 関数で描画する P と重なるはず．
        scatter!([z1],[z2],color=:red, alpha=0.4,label="(z^1,z^2)")
        plot(plt1,plt2,layout=(1,2))
    end,
    map(observe,[z1_slider,z2_slider])...,
)

[z1_slider,z2_slider,cross_pt] .|> display;
# -

# - ここからわかったことは二次元ユークリッド空間の第一象限の点は我々が最も馴染みがある直交座標系 $(z^1,z^2)$ による表示以外に別の表示方法が $(\ref{pqcurve})$ の意味で $p$ と $q$ の組み $(p,q)$ で与えられることがわかった. 二次元ユークリッド空間の点を $(\ref{pqcurve})$ の意味で $(p,q)$ と表示する座標系を曲線座標系と呼ぶことにする．

# # 曲線座標系での接ベクトル
#
# - 前章では曲線座標系で通常のユークリッド空間の点を捉えるアプローチを導入した．
# - ここでは曲線座標系での接ベクトルを導入する．曲線座標系での座標軸に沿った接ベクトルは直交座標系の場合と異なり, 注目している点の位置によって依存する. このことを Julia を用いて確認する．

# ## 一つのパラメータを動かしてみる
#
# - 曲線座標系 $(p,q)$ で $q$ を $q=q_0$ と適当な値 $q_0$ と固定し $p$ を変動させてみよう．これを Julia では下記の実装で行うことができる．読者はスライダーを動かすことで対話的にユークリッド空間の点 $P=P(p,q)$ がどのように変動するかを知ることができる.
# - もちろん $p$ を止めて $q$ を動かすこともできる. 適宜 `ui` 変数をいじると良い．

# +
p_slider = slider(0.001:0.1:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")

function vis_interactie_pqcurve(p,q)
    plt1=plot(xlim=xlim,ylim=ylim,xlabel="p",ylabel="q",aspect_ratio=:equal)
    scatter!([p],[q],label="(p,q)")
    plt2=plot(xlim=xlim,ylim=ylim,xlabel="z¹", ylabel="z²",aspect_ratio=:equal)
    vis_pqcurve(p, q)
    plot(plt1,plt2,layout=(1,2))
end

cross_pt = map(
    (p,q) -> begin 
        vis_interactie_pqcurve(p,q)
    end,
    map(observe,[p_slider,q_slider])...,
)


ui=[
    p_slider,
    #q_slider,
    cross_pt
] 

ui .|> display;
# -

# - 上記の実装で $p$ を変動することで $P(p,q=q_0)$ がどう振舞うのかが直感的にわかった．
# - $p$ を時間パラメータ $t$ とみなすと $P(p,q=q_0)$ の振る舞いは時刻 $p=p_0=t_0$ にいた粒子 $P(t=t_0):=P(p=t_0,q=q_0)$ が微小時間 $\Delta t$ が経過した時刻 $p=t_0+\Delta t$ での粒子の位置 $P(t=t_0+\Delta t)$ の動きを記述することと解釈することができる．この意味で次の極限
#
# $$
# \begin{equation}
#     \lim_{\Delta t \to 0} \frac{P(t=t_0+\Delta t)-P(t=t_0)}{\Delta t} \label{velocity}
# \end{equation}
# $$
#
# は時刻 $t=t_0$ での速度ベクトルと思える．以下で見るように $(\ref{velocity})$ は $C_{q=q_0}$ の $P(t=t_0)$ での接ベクトルともみなせる.
#
# - 加えて，上記の実装を実行して得られた左の図は $(p,q)$ を直交座標系としてみた $(p,q)$-平面とみなせ，スライド `p_slider ` に対応するスライダーを変化させると $(p,q)$ は $p$ 軸に沿って変動することがわかる．この意味で $(\ref{velocity})$ を $p$ 軸に沿った点 $P=P(t=t_0)$ における接ベクトルと呼ぶことにしよう．というのは $(\ref{velocity})$ は
#
# $$
# \begin{equation}
#     \lim_{\Delta t \to 0} \frac{P(t=t_0+\Delta t)-P(t=t_0)}{\Delta t} 
#     = 
#     \lim_{\Delta p \to 0} \frac{P(p=p_0+\Delta p,q=q_0)-P(p=p_0,q=q_0)}{\Delta p} 
#     \label{lim_along_p_axis}
# \end{equation}
# $$
#
# と変形でき, $(\ref{pqcurve})$ の対応によって, $(p,q)$-平面 で $(p=p_0,q=q_0)$ に向かう $p$ 軸と平行に沿って動かした方向への極限になっているからである．以上の議論から $p$ 軸に沿った点 $P=P(t=t_0)=P(p=p_0,q=q_0)$ における接ベクトルを次で定義する:
#
# $$
# \begin{equation}
# e_p(P)=\left.\frac{\partial P(p,q)}{\partial p}\right|_{(p,q)=(p_0,q_0)} \label{tl_wrt_p}
# \end{equation}
# $$
#
# しばしば $(\ref{tl_wrt_p})$ 右辺はどの点で微分をするかという情報を省いて
#
# $$
# \frac{\partial P}{\partial p}
# $$
#
# のように略記される.
#
#
# - 同様に $q$ 軸に沿った接ベクトル $e_q(P)$ も定義できる.

# ## 接ベクトルの可視化
#
# - $p$ 軸及び $q$ 軸に沿った接ベクトルを Julia で確かめよう.
# - 接ベクトルにおいて数値微分が必要にあるが [ForwardDiff.jl](https://github.com/JuliaDiff/ForwardDiff.jl) パッケージで賄っている.
# - 実装の便宜上 $P = P(p,q)=(\varphi^1(p,q),\varphi^2(p,q))$ とおいている．ここで
#
# $$
# \begin{equation}
# \varphi^1(p,q)=p^{-2/3}q^{-1/3},\quad \varphi^2(p,q)=p^{-1/3}q^{-2/3}
# \end{equation}
# $$
#
# である.

# +
φ¹(pq)=φ¹(pq...) # almost same as φ¹(pq[1], pq[2])
φ²(pq)=φ²(pq...)
∇φ¹=pq->ForwardDiff.gradient(φ¹,pq)
∇φ²=pq->ForwardDiff.gradient(φ²,pq)

function vis_tangent_vector(p,q)
    pq=[p,q]
    ∂P∂p = [∇φ¹(pq)[1],∇φ²(pq)[1]]
    ∂P∂q = [∇φ¹(pq)[2],∇φ²(pq)[2]]
    plot!(
        [φ¹(pq),φ¹(pq)+∂P∂p[1]],
        [φ²(pq),φ²(pq)+∂P∂p[2]],
        line=:arrow,
    )
    plot!(
        [φ¹(pq),φ¹(pq)+∂P∂q[1]],
        [φ²(pq),φ²(pq)+∂P∂q[2]],
        line=:arrow,
    )
end


p_slider = slider(0.001:0.05:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")

function vis_interactie_pqcurve(p,q)
    plt1=plot(xlim=xlim,ylim=ylim,xlabel="p",ylabel="q",aspect_ratio=:equal)
    scatter!([p],[q],label="(p,q)")
    plt2=plot(xlim=xlim,ylim=ylim,xlabel="z¹", ylabel="z²",aspect_ratio=:equal)
    vis_pqcurve(p, q)
    vis_tangent_vector(p, q)
    plot(plt1,plt2,layout=(1,2))
end

cross_pt = map(
    (p,q) -> begin 
        vis_interactie_pqcurve(p,q)
    end,
    map(observe,[p_slider,q_slider])...,
)


ui=[
    p_slider,
    q_slider,
    cross_pt
] 

ui .|> display;
# -

# ## 念のため検算
#
# SymPyを用いて記号計算と組み合わせて確認しておこう
# SymPy.jl に優しい形で `φ¹(p::Sym,q::Sym), φ²(p::Sym,q::Sym)` を定義しておく
#

@vars p q
φ¹(p::Sym,q::Sym) = 1/(∛(p))^2 * 1/∛(q)
φ²(p::Sym,q::Sym) = 1/∛(p) * 1/(∛(q))^2

# ### 偏微分を計算できるようにする

∂φ¹∂p(p::Sym,q::Sym)=diff(φ¹(p,q),p)
∂φ¹∂q(p::Sym,q::Sym)=diff(φ¹(p,q),q)
∂φ²∂p(p::Sym,q::Sym)=diff(φ²(p,q),p)
∂φ²∂q(p::Sym,q::Sym)=diff(φ²(p,q),q)

# ### `p`, `q` の型が実数などの数値を取れば ForwardDiffのロジックを使って微分計算をすることになる

∂φ¹∂p(p::Real,q::Real)=∇φ¹([p,q])[1]
∂φ¹∂q(p::Real,q::Real)=∇φ¹([p,q])[2]
∂φ²∂p(p::Real,q::Real)=∇φ²([p,q])[1]
∂φ²∂q(p::Real,q::Real)=∇φ²([p,q])[2]

# Julia のマルチプルディスパッチの機能を用いて p, q の型から振る舞いを変えることができる．
∂P∂p(p,q) = [∂φ¹∂p(p,q),∂φ²∂p(p,q)]
∂P∂q(p,q) = [∂φ¹∂q(p,q),∂φ²∂q(p,q)]

# ### SymPy で計算
#
# まずは記号計算で偏微分を計算する

∂P∂p(p,q)

# 次にForwardDiffを呼ぶようにランダムな値を生成しその出力を見る

pq=[rand(), rand()]
∂P∂p(pq...)

# SymPyのオブジェクト p,q に具体的な値を代入して一致しているかを調べる

map(x->x(p=>pq[1],q=>pq[2]), ∂P∂p(p,q))

∂P∂q(p,q)

# 以下同様に $q$ についての偏微分でも確かめられる

∂P∂q(pq...)

map(x->x(p=>pq[1],q=>pq[2]), ∂P∂q(p,q))
