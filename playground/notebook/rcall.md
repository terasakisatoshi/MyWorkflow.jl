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

# RCall Example

```julia
using RCall
using Plots
```

```julia
x = randn(10)
```

```julia
Plots.plot(x)
Plots.scatter!(x)
```

```julia
@rput x
```

```julia
R"plot(x, type='b')"
```
