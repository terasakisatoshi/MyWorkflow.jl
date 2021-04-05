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
    display_name: Julia 1.4.1
    language: julia
    name: julia-1.6
---

# ヒストグラム平坦化


# 準備


## Load Julia Packages

```julia
using Images
using TestImages
using Plots
```

## read testimage

```julia
c = testimage("c")
```

## Visualize gray scale image histogram

```julia
data = reshape(255 .* channelview(c), prod(size(c)))
histogram(data, bins=0:255,normalize=:pdf)
```

## Visualize cumulative distribution function (so called CDF)

```julia
i2c = Dict{Int,Int}()
for i in 0:255
    i2c[i] = 0 
end

for i in Int.(255 .* channelview(c))
    i2c[i] += 1
end
```

```julia
arr = [i2c[i] for i in 0:255]
cdf = [sum(arr[begin:i]) for i in 1:length(arr)]
plot(cdf ./ length(c), label="CDF")
```

# Histogram Equalization


- $q$ を画像の輝度の分布を表す確率密度関数とする. ヒストグラムを平坦化することは分布が（なるべく)一様分布に近似されれば良い.つまり累積分布関数が $y=ax$ のように原点と積分範囲の右端(画像であれば255=256-1)で $y=1$ となる一次関数になっていれば良い. 
- 今述べたことを定式化する. $X$ を画像の分布を表す確率変数だとする. $Y$ をヒストグラム平坦化により得られら分布とし滑らかに $Y=f(X)$ と変化したとする. さらに変換が可逆だと仮定する. $p$ を $Y$ の確率密度函数とすれば, 次のことを要請する.

$$
\frac{y}{255} = \int_{0}^{y} p(\tilde{y})d\tilde{y} 
$$


一般に $Y=f(X)$ と変換された確率変数の確率密度関数 $p$ は

$$
p(y) = \int \delta(y-f(x))q(x)dx
$$

である. この一般論を上式の右辺に適用すれば $p(y) = \frac{q(x)}{f'(x)}\ \mathrm{where}\ y=f(x)$ が従う.

$$
\begin{aligned}
\frac{1}{255} &= \frac{d}{dy}\left(\frac{y}{255}\right) \\
              &= \frac{d}{dy}\int_{0}^{y} p(\tilde{y})d\tilde{y} \\
              &= p(y) \\
              &= \frac{q(x)}{f'(x)}\ \mathrm{where}\ y=f(x) \\
\end{aligned}
$$

よって

$$
f'(x) = 255q(x)
$$

要するに欲しい変換は累積分布函数に255(確率変数 $X$ がとる最大値) を乗じたものである.

$$
f(x) = 255 \int_{0}^x q(\tilde{x}) d\tilde{x}
$$

これを画像処理に適用することを考えると積分は離散和になる. $q(x)$ は輝度が$x\in [0, 255]$である確率になる. 平たくいうと $x$ での（正規化された）ヒストグラムの値である．これを踏まえて下記のように実装をしてみよう.

```julia
n_pixels = length(c)
function hist_eq(p)
    s = 0
    for i in 0:p
        s += i2c[i]
    end
    floor(255 * s / n_pixels)
end
```

```julia
new_c = hist_eq.(255 .* channelview(c))
```

```julia
colorview(Gray, new_c ./ 255)
```

```julia
histogram(new_c[:], normalize=:pdf, bins=0:255)
```

```julia
new_i2c = Dict{Int,Int}()
for i in 0:255
    new_i2c[i] = 0 
end

for i in new_c
    new_i2c[i] += 1
end
```

# 結果の確認

```julia
arr = [new_i2c[i] for i in 0:255]
cdf = [sum(arr[begin:i]) for i in 1:length(arr)]
plot(cdf ./ length(c))
# 直線になっている様子がわかるはず
```
