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

```julia
print("Hello world")
```

```julia
using Plots
```

# Rapid Visualization on Jupyter

Just `add IJulia.clear_output(true)` and display `p` plot object simultaneously will improve your visualizatoin life

```julia
ps = []
for t in 1:0.1:10
    IJulia.clear_output(true)
    p = plot(x -> sin(x + t))
    p |> display
    push!(ps, p)
end
```

# Dump result as tmp.gif

```julia
@gif for p in ps
    plot(p)
end
```
