# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.3.4
#   kernelspec:
#     display_name: Julia 1.3.1
#     language: julia
#     name: julia-1.3
# ---

# + [markdown] toc=true
# <h1>Table of Contents<span class="tocSkip"></span></h1>
# <div class="toc"><ul class="toc-item"><li><span><a href="#曲線座標系での接ベクトルのお話" data-toc-modified-id="曲線座標系での接ベクトルのお話-0"><span class="toc-item-num">0&nbsp;&nbsp;</span>曲線座標系での接ベクトルのお話</a></span><ul class="toc-item"><li><span><a href="#概要" data-toc-modified-id="概要-0.1"><span class="toc-item-num">0.1&nbsp;&nbsp;</span>概要</a></span></li><li><span><a href="#必要な-Julia-のライブラリを導入" data-toc-modified-id="必要な-Julia-のライブラリを導入-0.2"><span class="toc-item-num">0.2&nbsp;&nbsp;</span>必要な Julia のライブラリを導入</a></span></li></ul></li><li><span><a href="#曲線座標系の導入" data-toc-modified-id="曲線座標系の導入-1"><span class="toc-item-num">1&nbsp;&nbsp;</span>曲線座標系の導入</a></span><ul class="toc-item"><li><span><a href="#試しに描画してみる" data-toc-modified-id="試しに描画してみる-1.1"><span class="toc-item-num">1.1&nbsp;&nbsp;</span>試しに描画してみる</a></span><ul class="toc-item"><li><span><a href="#対話的操作で確認" data-toc-modified-id="対話的操作で確認-1.1.1"><span class="toc-item-num">1.1.1&nbsp;&nbsp;</span>対話的操作で確認</a></span></li></ul></li><li><span><a href="#曲線による平面の点の特徴付け" data-toc-modified-id="曲線による平面の点の特徴付け-1.2"><span class="toc-item-num">1.2&nbsp;&nbsp;</span>曲線による平面の点の特徴付け</a></span><ul class="toc-item"><li><span><a href="#確認のため描画" data-toc-modified-id="確認のため描画-1.2.1"><span class="toc-item-num">1.2.1&nbsp;&nbsp;</span>確認のため描画</a></span></li></ul></li></ul></li><li><span><a href="#曲線座標系での接ベクトル" data-toc-modified-id="曲線座標系での接ベクトル-2"><span class="toc-item-num">2&nbsp;&nbsp;</span>曲線座標系での接ベクトル</a></span><ul class="toc-item"><li><span><a href="#一つのパラメータを動かしてみる" data-toc-modified-id="一つのパラメータを動かしてみる-2.1"><span class="toc-item-num">2.1&nbsp;&nbsp;</span>一つのパラメータを動かしてみる</a></span></li><li><span><a href="#接ベクトルの可視化" data-toc-modified-id="接ベクトルの可視化-2.2"><span class="toc-item-num">2.2&nbsp;&nbsp;</span>接ベクトルの可視化</a></span></li><li><span><a href="#念のため検算" data-toc-modified-id="念のため検算-2.3"><span class="toc-item-num">2.3&nbsp;&nbsp;</span>念のため検算</a></span><ul class="toc-item"><li><span><a href="#偏微分を計算できるようにする" data-toc-modified-id="偏微分を計算できるようにする-2.3.1"><span class="toc-item-num">2.3.1&nbsp;&nbsp;</span>偏微分を計算できるようにする</a></span></li><li><span><a href="#p,-q-の型が実数などの数値を取れば-ForwardDiffのロジックを使って微分計算をすることになる" data-toc-modified-id="p,-q-の型が実数などの数値を取れば-ForwardDiffのロジックを使って微分計算をすることになる-2.3.2"><span class="toc-item-num">2.3.2&nbsp;&nbsp;</span><code>p</code>, <code>q</code> の型が実数などの数値を取れば ForwardDiffのロジックを使って微分計算をすることになる</a></span></li><li><span><a href="#SymPy-で計算" data-toc-modified-id="SymPy-で計算-2.3.3"><span class="toc-item-num">2.3.3&nbsp;&nbsp;</span>SymPy で計算</a></span></li></ul></li></ul></li><li><span><a href="#ある方向に対しての接ベクトル" data-toc-modified-id="ある方向に対しての接ベクトル-3"><span class="toc-item-num">3&nbsp;&nbsp;</span>ある方向に対しての接ベクトル</a></span></li><li><span><a href="#接空間が導入できた" data-toc-modified-id="接空間が導入できた-4"><span class="toc-item-num">4&nbsp;&nbsp;</span>接空間が導入できた</a></span></li><li><span><a href="#いやでも，目で見えるじゃん，比較できそうじゃん" data-toc-modified-id="いやでも，目で見えるじゃん，比較できそうじゃん-5"><span class="toc-item-num">5&nbsp;&nbsp;</span>いやでも，目で見えるじゃん，比較できそうじゃん</a></span></li><li><span><a href="#せやな！それを正当化するのが接続とか共変微分とかの話やで！" data-toc-modified-id="せやな！それを正当化するのが接続とか共変微分とかの話やで！-6"><span class="toc-item-num">6&nbsp;&nbsp;</span>せやな！それを正当化するのが接続とか共変微分とかの話やで！</a></span></li></ul></div>
# -

# # 曲線座標系での接ベクトルのお話
# ## 概要
#   - 藤原著「情報幾何学の基礎」牧野書店 Chapter1 のモチベーションを Julia を介して理解しようという試みのノートです．
#   

# ## 必要な Julia のライブラリを導入

using Plots
using Interact
using ForwardDiff
using SymPy
using LaTeXStrings

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
    plot!(x,p*x.^2,color=:blue, label=L"C_p")
    plot!(q*y.^2,y,color=:orange, label=L"C_q")
    scatter!([φ¹(p,q)],[φ²(p,q)], label=L"P")
end

p₀, q₀=(1.,2.4) # 適当に定める.
plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2")
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
            plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2")
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

z1_slider = slider(0.001:0.1:3,label="z¹")
z2_slider = slider(0.001:0.1:3,label="z²")

cross_pt = map(
    (z1,z2) -> begin 
        p, q = z2/z1^2, z1/z2^2 # (2) の実装
        plt1=plot(xlim=xlim,ylim=ylim,xlabel=L"p", ylabel=L"q",aspect_ratio=:equal)
        scatter!(plt1, [p],[q], label=L"(p,q)")
        plt2=plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2",aspect_ratio=:equal)
        # ここで求めたp, q で定まる二次曲線 C_p, C_q の曲線を描画する．
        vis_pqcurve(p, q)
        # (z^1,z^2) の点を描画. vis_pqcurve 関数で描画する P と重なるはず．
        scatter!([z1],[z2],color=:red, alpha=0.4,label=L"(z^1,z^2)")
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
    plt1=plot(xlim=xlim,ylim=ylim,xlabel=L"p",ylabel=L"q",aspect_ratio=:equal)
    scatter!([p],[q],label=L"(p,q)")
    plt2=plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2",aspect_ratio=:equal)
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
        label=L"e_p(P)"
    )
    plot!(
        [φ¹(pq),φ¹(pq)+∂P∂q[1]],
        [φ²(pq),φ²(pq)+∂P∂q[2]],
        line=:arrow,
        label=L"e_q(P)"
    )
end


p_slider = slider(0.001:0.05:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")

function vis_interactie_pqcurve(p,q)
    plt1=plot(xlim=xlim,ylim=ylim,xlabel=L"p",ylabel=L"q",aspect_ratio=:equal)
    scatter!([p],[q],label=L"(p,q)")
    plt2=plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2",aspect_ratio=:equal)
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

∂P∂p(Sym("p"),Sym("q"))

# 次にForwardDiffを呼ぶようにランダムな値を生成しその出力を見る

pq=[rand(), rand()]
∂P∂p(pq...)

# SymPyのオブジェクト p,q に具体的な値を代入して一致しているかを調べる

symp, symq = Sym("p"), Sym("q")
map(x->x(symp=>pq[1],symq=>pq[2]), ∂P∂p(symp,symq))

∂P∂q(Sym("p"),Sym("q"))

# 以下同様に $q$ についての偏微分でも確かめられる

∂P∂q(pq...)

map(x->x(p=>pq[1],q=>pq[2]), ∂P∂q(p,q))

# 良さそうである

# # ある方向に対しての接ベクトル
#
# - 我々は $p$ 軸に沿った接ベクトルを導入した, これは $p$ に関係ないパラメータを(この文脈では $q$ のこと)固定して $p$ を変化させたときの(曲線座標系が導入された) $(z^1,z^2)$ - 平面での点 $P(p,q)$ の動く方向を表していた．$q$ 軸に沿った接ベクトルも同様である．では, $p$, $q$ が同時に動くとどうなるか？その場合の $P(p,q)$ の振る舞いはどう記述できるのかをみてみよう.
# - 時刻 $t$ での パラメータ $p$, $q$ の ($p$, $q$) - 平面でみたときの位置が $(p(t),q(t))$ と書けるとしよう. もう少し形式ばると $p$, $q$ は $t$ についての滑らかな関数となってるとする. ここでの滑らかさは必要に応じて要請される回数ぐらいは微分可能であることを満たすいい感じの条件であるとしておく．
# - 我々の関心はある時刻での $t=t_0$ の微小変化をみたいのでそのある時刻を基準にする, すなわち, $t_0=0$ と仮定して良く. $p(t), q(t)$ の $t$ についての定義域は $t=t_0$ の周りの領域で定義されていれば良い．後々のために $t=0$ での $p(t), q(t)$ の導関数の値 $v_p$, $v_q$を各々次のようにおく:
#
# $$
# \begin{align}
#     v_p := \dot{p}(t=0) := \left. \frac{d p}{d t}(t) \right|_{t=0} \\
#     v_q := \dot{q}(t=0) := \left. \frac{d q}{d t}(t) \right|_{t=0} \\
# \end{align}
# $$

# +
p₀, q₀ = 3., 3. # 時刻 t=0 での初期位置
# v_q のような q の下付きが備わっていないので vp, vq という変数名を採用する
vp, vq = 3*1.5 ,3*1.25 # 右辺は適当に決めた．読者は好きなようにいじって良い

p(t::Float64) = vp*t + p₀
q(t::Float64) = vq*t + q₀
φ¹(t::Float64) = p(t)
φ²(t::Float64) = q(t)
φ(t::Float64) = (p(t),q(t))
# -

# - $t$ を変動させたときの $(p,q)$-平面での $(p(t),q(t))$ の動き，パラメータが定める $(z^1, z^2)$-平面での点 $P:=P(p,q)$ の動きをみておくことにする．

# +
t_slider = slider(-0.5:0.01:0.5,label="t")
# value を指定することで t のスライダーを変化させたときに p,qのスライダーが動くようになる．
# だたしこのアプローチだと，p, q　を動かす操作ができない
p_slider = slider(0.001:0.01:5.,value=map(a->p(a), observe(t_slider)),label="p")
q_slider = slider(0.001:0.01:5.,value=map(a->q(a), observe(t_slider)),label="q")




function vis_interactive_pqcurve(p, q)
    xlim=(0,5)
    ylim=(0,5)
    plt1 = plot(xlim=xlim, ylim=ylim, xlabel=L"p", ylabel=L"q", aspect_ratio=:equal)
    plot!(plt1, [p₀-vp,p₀+vp],[q₀-vq, q₀+vq], color=:green, label=L"(v_p,v_q)")
    scatter!(plt1, [p],[q],label=L"(p,q)")
    plt2 = plot(xlim=xlim, ylim=ylim, xlabel=L"z^1", ylabel=L"z^2", aspect_ratio=:equal)
    vis_pqcurve(p, q)
    vis_tangent_vector(p, q)
    plot(plt1, plt2,layout=(1,2))
end


ui = map(
    t ->begin 
        vis_interactive_pqcurve(p(t),q(t))
        
    end,
    observe(t_slider)
)

vbox([
    hbox(t_slider, p_slider, q_slider),
    ui
])

# -

# - 左の緑色の線は左側の空間上に伸びる $(v_p,v_q)$ を傾きに持つ直線である．$t$ が動くと オレンジ色の $(p,q)$ がその直線状を動くことがわる．
# $P$ もなんとなく$e_p(P)$ または $e_q(P)$ の向く方向へと進んでいる気がする．
# - さて，今一度座標関数系の定義に戻ると $P=P(p,q)=(p^{-2/3}q^{-1/3}, p^{-1/3}q^{-2/3})$ であった，右辺の各々の成分は $p$, $q$ についての関数であるが，我々が今見ている文脈ではさらに $t$ についての関数だとも見ることができる．その意味で $P$ は $t$ 依存するベクトル値関数とみなせる. その意味で得られる $P(t)$ の微分は（各成分に対して）合成関数の連鎖律を用いると
#
# $$
# \begin{equation}
# \frac{d P(t)}{dt} = \dot{p}(t)\left.\frac{\partial P(p,q)}{\partial p}\right|_{(p,q)=(p(t),q(t))} +  \dot{q}(t)\left.\frac{\partial P(p,q)}{\partial q}\right|_{(p,q)=(p(t),q(t))}
# \end{equation}
# $$
#
# となる．これから特に $t=0$ の場合 
#
# $$
# \begin{equation}
# \left. \frac{d P(t)}{dt}\right|_{t=0} = v_p e_p(P) +  v_q e_q(P) \label{tangent_vec_along_t}
# \end{equation}
# $$
#
# ということになる．したがって，この値 $\ref{tangent_vec_along_t}$ は $p$,$q$ 軸に沿った接ベクトルのの線形結合でかける．しかも係数は各々の軸に$v_p$,$v_q$が掛かっている．この意味で $\ref{tangent_vec_along_t}$ を $(v_p,v_q)$ 方向の接ベクトルと定義しよう．
# 特に $(v_p,v_q)=(1,0)$ の場合は $p$ 方向の接ベクトルになるが，これは $p$ 軸に沿った接ベクトル $e_p(P)$ そのものである．
#
#

# # 接空間が導入できた

# Remark: 上の実装で確認したように,
#  $(z^1,z^2)$-平面 では $(v_p, v_q)$ の方向に $P=P(p,q)$ は動いていないが $(p,q)$-平面で見ると $(v_p, v_q)$ 方向に伸びる直線上に伸びている様子がわかる．
#
# ところで $e_p(P), e_q(P)$ は $(z^1,z^2)$ の上で $P$ から伸びる一次独立なベクトルの組みになる．これは $P = P(p,q)=(\varphi^1(p,q),\varphi^2(p,q))$ ,ただし,
#
# $$
# \begin{equation}
# \varphi^1(p,q)=p^{-2/3}q^{-1/3},\quad \varphi^2(p,q)=p^{-1/3}q^{-2/3}
# \end{equation}
# $$
#
# で与えられる写像のヤコビ行列の行列式がゼロでないことからわかる．実際，ヤコビ行列は $e_p(P), e_q(P)$ を(縦ベクトルと見てそれらを横に)並べて得られるからである．
#
# 以上のことから次のことがわかる．
#
# - $(z^1,z^2)$-空間上の点 $P$ を曲線座標系 $(p,q)$ の立場から見て解析する際，
# 通常の（直交座標系が導入されている）空間と同様に$P$での接ベクトルの概念が重要になる.
# $P$での接ベクトルは互いに独立な $p$ 方向の接ベクトル $e_p(P)$ と $q$ 方向の接ベクトル $e_p(P)$ の線形結合で表されることがわかった.
# - よって $P$での接ベクトル全体は$e_p(P)$と$e_q(P)$を基底とするベクトル空間をなす.曲線座標系$(p,q)$ が入った空間上の点 $P$ での接空間と呼ぶ. $P$ での接空間を $V_P$ と表記しよう(本当は $T_pM$ のように書いた方がかっこいい)．
#
#
#
#

# - さて, 接ベクトルの可視化の実装を思い出そう. もう一度同じコードを貼り付けている．

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
        label=L"e_p(P)"
    )
    plot!(
        [φ¹(pq),φ¹(pq)+∂P∂q[1]],
        [φ²(pq),φ²(pq)+∂P∂q[2]],
        line=:arrow,
        label=L"e_q(P)"
    )
end


p_slider = slider(0.001:0.05:3,label="p")
q_slider = slider(0.001:0.1:3,label="q")

function vis_interactie_pqcurve(p,q)
    plt1=plot(xlim=xlim,ylim=ylim,xlabel=L"p",ylabel=L"q",aspect_ratio=:equal)
    scatter!([p],[q],label=L"(p,q)")
    plt2=plot(xlim=xlim,ylim=ylim,xlabel=L"z^1", ylabel=L"z^2",aspect_ratio=:equal)
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

# - ここで重要なのは 曲線座標系が入った $(z^1,z^2)$-空間では基底であった $e_p(P)$, $e_q(P)$ が変化する. これは互いに異なる点 $P_1$ $P_2$ において $e_p(P_1)$ $e_p(P_2)$ が一般に同じでないことを意味している．何を当たり前のことをいってるんだ？と思われるかもしれない読者はある意味で Julia 実装の世界にのめり込んでしまっている（これは良いこと）．通常の直交座標系が入った通常の空間では接ベクトルの基底は点の位置によらない標準基底がとれてしまうのであまり意識してなかったはずである．
# - Juliaの世界にのめり込んでしまった読者は接空間，接ベクトルという言葉に出会った時「それはどの空間で考えていますか？，どの点での接空間を考えてますか」と質問したくなるだろう. 互いに異なる $P_1$, $P_2$ に対応する接ベクトル $V_{P_1}$, $V_{P_2}$ から一つずつ要素 $v_{P_1}$, $v_{P_2}$ をとってきた時にこれらを直接比較したり足したり，引いたりすることに意味がないとかんじるからである．
#

# # いやでも，目で見えるじゃん，比較できそうじゃん
#
# - $P_1$ と $P_2$ が十分近かったら，近似できそうじゃん？可視化して見えるベクトルを何かしらの方法でズズズーっと平行移動のように引っ張ってきて $P_1$ に持っていってそこで比較すればいいんじゃないの？
#
# # せやな！それを正当化するのが接続とか共変微分とかの話やで！

# - 教科書にある接続係数の話を読んで計算頑張りませう！
# - 糸冬
