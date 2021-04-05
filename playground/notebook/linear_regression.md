# -*- coding: utf-8 -*-
---
jupyter:
  jupytext:
    formats: jl,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.5.2
  kernelspec:
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
---

# Linear Regression

`MLJ.jl` の練習として線形回帰の問題を解くことを考える.


# 定式化

次元が $n$ の説明変数 $x=[x_1,\dots,x_n]^\top$ と 1 次元の目的変数 $y$ のペアからなるデータ $(x,y)$
からなる $N$ この要素を持つ集合を $\mathcal{D}$ とおく:

$$
\mathcal{D} = \{\, (x^{(i)},y^{(i)})\mid i = 1,2,\dots, N  \,\}.
$$

説明変数 $x$ と目的変数 $y$ を関連づけるモデルとして次の形をしてるパラメータ $\beta=[\beta_0,\beta_1,\dots,\beta_n]$ を持つ線形モデルであるとする:

$$
y = m(x;\beta)=\beta_0 + \beta_1 x_1 + \dots \beta_n x_n.
$$

この設定のもとで与えられているデータセットに適合するパラメータ $\beta$ を求めたい. 
我々は適合の指標としてパラメータ $\beta$ に依存する損失関数 $L=L(\beta)$ を定義し, その損失関数の最小値を与える時の $\beta=\hat{\beta}$ を与える方針を取る. ここでは損失関数として次の形のものを採用する:

$$
L(\beta) = \frac{1}{2}\sum_{i=1}^N (m(x^{(i)};\beta)-y^{(i)})^2 
$$

各データの目的変数 $y^{(i)}$ と説明変数 $x^{(i)}$ に対するモデルの出力 $\hat{y}^{(i)}:=m(x^{(i)}; \beta)$ の二乗誤差が最小になるように設計している. この場合, 求めたいパラメータである $\hat{\beta}$ は次の極値問題を解けば良いことになる:

$$
\nabla_{\beta} L(\beta) = 
\begin{bmatrix}
\frac{\partial L(\beta)}{\partial \beta_0} \\
\frac{\partial L(\beta)}{\partial \beta_1} \\
\vdots \\
\frac{\partial L(\beta)}{\partial \beta_n}
\end{bmatrix}
=\bf{0}
$$



## 極値問題を解く

上記の $L(\beta)$ を以下で述べるようにベクトルのノルムで表記し，それを用いてベクトルに対する微分の結果を用いて解くことにする.

### 記号の準備

$y=[y^{(1)},\dots,y^{(N)}]^\top$, $\hat{y}=[\hat{y}^{(1)},\dots,\hat{y}^{(N)}]^\top$ とおく.
説明変数 $x^{(i)}=[x_1^{(i)},\dots,x_n^{(i)}]^\top$ を用いて得られる行列 $X$ を次のように定める:

$$
X = \begin{bmatrix}
1      & x_1^{(1)} & x_2^{(1)} & \dots  & x_n^{(1)} \\
1      & x_1^{(2)} & x_2^{(2)} & \dots  & x_n^{(2)} \\
\vdots & \vdots    & \vdots    &        & \vdots    \\
1      & x_1^{(N)} & x_2^{(N)} & \dots  & x_n^{(N)}
\end{bmatrix}_{\textstyle .}
$$

これはしばしば計画行列などと呼ばれる. さて $x^{(i)}$ に対するモデルの出力は次のように変形できることに注意する:

$$
\begin{align}
\hat{y}^{(i)} &= m(x^{(i)};\beta) \\
              &= [1,x_1^{(i)},\dots,x_n^{(i)}] 
              \begin{bmatrix}
                  \beta_0 \\
                  \beta_1 \\
                  \vdots \\
                  \beta_n
              \end{bmatrix}_{\textstyle .}
\end{align}
$$

したがって $\hat{y} = X \beta$ とかけるので $L(\beta)$ は

$$
\begin{align}
L(\beta) &= \frac{1}{2}\sum_{i=1}^N (m(x^{(i)};\beta)-y^{(i)})^2 \\
         &= \frac{1}{2} \langle \hat{y}-y, \hat{y}-y\rangle \\
         &= \frac{1}{2} \langle X \beta -y, X\beta -y \rangle \\
\end{align}
$$

となる.



## 勾配ベクトルの計算

$z=z(\beta)=X^\top\beta-y$ とし $z_i$ を $z$ の第 $i$ 番目の成分とする. 定義によって 
$$
\begin{align}
L(\beta) &= \frac{1}{2}\langle z,z \rangle = \frac{1}{2}\sum_{i=1}^n z_i(\beta)^2, \\
\frac{\partial z_i}{\partial \beta_j} &= X_{ij} , \\
\frac{\partial}{\partial \beta_j} L(\beta) 
&= \sum_{i=1}^n z_i(\beta) \frac{\partial z_i}{\partial \beta_j} \\
&= \sum_{i=1}^n z_i(\beta) X_{ij}
\end{align}
$$

などから

$\nabla_{\beta} L(\beta) = X^\top z = X^\top(X\beta - y)$ となる. $\nabla_{\beta} L(\beta)=0$ を $\beta$ についてとくと $\beta = (X X^\top)^{-1}X^\top y$ が得られる. したがって 

$$
\hat{\beta} = (XX^\top)^{-1}X^\top y
$$

となる.


# 実装

- 住宅の価格予測をする Boston dataset があるのでそれを試してみよう. 説明変数は `Crim`, `Zn`, `Indus`, `NOx`, `Rm`, `Age`, `Dis`, `Rad`, `Tax`, `PTRatio`, `Black`, `LStat` という 12 項目からなる.
- MLJ で提供されている `@load_boston` マクロを用いてデータをロードできる.


## パッケージの読み込み

```julia
using LinearAlgebra

using DataFrames
using LaTeXStrings
using MLJ
using OffsetArrays
using Plots
```

```julia
X, y = @load_boston
variable_names = keys(X)
```

## 計画行列の作成

```julia
X, y = @load_boston
ndata = length(y)
X = hcat(ones(ndata), [X[k] for k in variable_names]...)
X |> size
```

## $\widehat{\beta}$ の計算

```julia
β̂ = inv(X' * X) * X' * y
```

```julia
## 結果の表示
function show_result(β, variable_names)
    for (i, (β̂_i, k)) in enumerate(zip(β, [:bias, variable_names...]))
        println("k = $k, β̂_$(i - 1) = $(β̂_i)")
    end
end

show_result(β̂, variable_names)
```

## RMS の計算

- root mean squared error を計算する

```julia
ŷ = X * β̂
round(rms(ŷ, y), sigdigits=4)
```

## 説明変数が１次元の例

- 説明変数の一つで線形モデルを解く. そうするとモデルは二次元平面上の線分として表示できるのでデータを可視化できる．ここでは `LStat` という項目を取り上げて調べてみよう.

```julia
X_, y = @load_boston
name = :LStat
ndata = length(y)
X = hcat(ones(ndata), [X_[k] for k in [name]]...)
β̂ = inv(X' * X) * X' * y
show_result(β̂,[name])
```

```julia
β̂ = OffsetArray(β̂, 0:length(β̂) - 1)
p = plot(xlabel="x", ylabel="y")
scatter!(p, X_[variable_names[1]], y, label=String(variable_names[1]))
plot!(p, x -> β̂[0] + β̂[1] * x, xlim=[minimum(X_[name]),maximum(X_[name])], label=L"y=\beta_0+\beta_1 x")
```

# MLJ で解いてみる

- 上記では線形モデルによる回帰問題を解いた. `MLJ.jl` では `LinearRegressor` という名前で上記と同様のことをすることができる機能を備えている.

```julia
using MLJ

@load LinearRegressor pkg = MLJLinearModels 
```

`fit_intercept=true` を指定しておくことで切片 $\beta_0$ も考慮できるようになる.

```julia
linearmodel = LinearRegressor(fit_intercept=true)
```

`machine(model, 説明変数, 目的変数)` により学習器を作る.

```julia
X, y = @load_boston
m = machine(linearmodel, X, y)
```

`fit!` によりモデルを学習させることができる.

```julia
fit!(m)
```

学習によってえられたモデルのパラメータを取得しその結果を表示する. この結果はスクラッチで作ったモデルと一致するはずである.

```julia
fp = fitted_params(m)
coefs = fp.coefs
intercept = fp.intercept
for (name, val) in coefs
    println("$(rpad(name, 8)):  $(round(val, sigdigits=3))")
end
println("Intercept: $(round(intercept, sigdigits=3))")
```

ついでに説明変数が一変数の場合でも同様の結果が得られることを確認しよう.

```julia
X_, y = @load_boston
variable_names = [:LStat]
X = DataFrame([X_[variable_names[1]]])
m = machine(linearmodel, X, y)
fit!(m)
fp = fitted_params(m)
β̂ = [fp.intercept, [c.second for c in fp.coefs]...]
```

```julia
β̂ = OffsetArray(β̂, 0:length(β̂) - 1)
p = plot(xlabel="x", ylabel="y")
scatter!(p, X_[variable_names[1]], y,label=String(variable_names[1]))
plot!(p, x -> β̂[0] + β̂[1] * x, xlim=[minimum(X_[name]),maximum(X_[name])], label=L"y=\beta_0+\beta_1 x")
```
