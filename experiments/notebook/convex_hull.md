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
    display_name: Julia 1.5.2
    language: julia
    name: julia-1.5
---

# Convex hull

```julia
using LazySets
using Plots
```

```julia
points(N) = [randn(2) for i in 1:N]
v = points(30)
hull = convex_hull(v)
p = plot([Singleton(vi) for vi in v])
plot!(p, VPolygon(hull), alpha=0.2)
```
