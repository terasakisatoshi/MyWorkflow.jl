---
jupyter:
  jupytext:
    encoding: '# -*- coding: utf-8 -*-'
    formats: jl,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.12.0
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

# 主成分分析をする


- PCA の例として MNIST 画像 dataset を主成分分析を行う


## Load modules

```julia
using MLDatasets
using Images
using Statistics
using LinearAlgebra
using Plots
```

## Download MNIST dataset

```julia
MNIST.download(;i_accept_the_terms_of_use=true)
```

```julia
train_x, train_y = MNIST.traindata()
test_x, test_y = MNIST.testdata()
```

## Study data

```julia
?MNIST.convert2image
```

```julia
MNIST.traintensor(1)|>MNIST.convert2image
```

```julia
train_x |> size # W, H, Num_data
```

```julia
N = size(train_x)[end]
```

```julia
train_x_nhw = permuteddimsview(train_x, (3, 2, 1)); # transpose so that it has NxHxW layout
```

```julia
id = 4
colorview(Gray, train_x_nhw[id, :, :]) |> display
println("label = $(train_y[id])")
```

# Apply PCA to 7

```julia
sevens = train_x[:, :, train_y .== 7];
```

```julia
μ_sevens = dropdims(mean(sevens, dims=3),dims=3);
```

```julia
colorview(Gray, μ_sevens')
```

```julia
colorview(Gray,(sevens[:,:,1] .- μ_sevens)')
```

```julia
X_ = sum(sevens .- μ_sevens, dims=3)/√N
X = reshape(X_, 784)
X |> size
```

```julia
A = X * X'; # variance-covariance matrix w.r.t sample
```

```julia
F = eigen(A);
λ = F.values[end]
v = F.vectors[:, end];
```

```julia
# visualize the first principal vector
normalize_img(v) = (v .- minimum(v)) ./ (maximum(v)-minimum(v))
colorview(Gray, reshape(normalize_img(v),28,28)') |> display
v
```

```julia
λs = F.values[end:-1:end-5]
vs = F.vectors[:, end:-1:end-5]
normalize(v) = (v .- minimum(v)) ./ (maximum(v)-minimum(v))
gs = []
for i in 1:size(vs)[2]
    v = reshape(vs[:, i] |> normalize,28,28)'
    push!(gs, colorview(Gray, v))
end

colorview.(Gray,gs)
```

# Apply PCA to whole dataset

```julia
train_x, train_y = MNIST.traindata()
μ_train_x = mean(train_x,dims=3)
X_ = sum(train_x .- μ_train_x, dims=3)/√N
X = reshape(X_, 784)
A = X * X';
```

```julia
F=eigen(A)
λ1 = F.values[end]
λ2 = F.values[end-1]
λ3 = F.values[end-2]
w1 = F.vectors[:, end]
w2 = F.vectors[:, end-1]
w3 = F.vectors[:, end-2];
```

## Project 2D space

```julia
p = plot()
data = reshape(train_x,(28^2, N))
for i in 1:10
    d = data[:,train_y .== (i-1)][:, 1:100]
    x1 = w1' * d
    x2 = w2' * d
    scatter!(p,x1,x2, label=false, color=palette(:tab10)[i])
end
p
```

## Project 3D space

```julia
plotlyjs()

p = plot(xlabel="x", ylabel="y" , zlabel="z")
data = reshape(train_x,(28^2, N))
target = [0,1,2,3,4,5,6,7,8,9]
for i in target
    d = data[:,train_y .== i][:, 1:100]
    x1 = w1' * d
    x2 = w2' * d
    x3 = w3' * d
    color = palette(:tab10)[i+1]
    scatter!(p, 
        x1, x2, x3, 
        label=false, color=color,
        markersize = 2,
    )
end

display(palette(:tab10)) # show color palette
p
```
