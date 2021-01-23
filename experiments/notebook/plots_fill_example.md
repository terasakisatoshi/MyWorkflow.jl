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
    display_name: Julia 1.5.1
    language: julia
    name: julia-1.5
---

```julia
using Plots
```

```julia
x = range(-pi,pi,length=100)
y = sin.(x)
plot(aspect_ratio=:equal,xlim=[-pi,pi])
plot!(sin,color=:red)
plot!(x, y, fill=y .+ 1,color=:green)
plot!(x, y, fill=y .- 1,color=:blue)
```

```julia
x = range(-pi,pi,length=100)
y = sin.(x)
l = -ones(length(y))
u = ones(length(y))
plot(aspect_ratio=:equal,xlim=[-pi,pi])
plot!(sin, ribbons=[l, u], color=:blue,label=:none)
plot!(sin,color=:red,label=:none)
```

```julia
x=range(-pi,pi,length=200)
plot(x,sin.(x),fill=(x-> sin(x)>0 ? sin(x) : 0),alpha=0.5)
```
