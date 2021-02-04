---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.2'
      jupytext_version: 1.9.1
  kernelspec:
    display_name: Julia 1.5.3
    language: julia
    name: julia-1.5
---

```julia
using WAV
using Interact
```

```julia
freqs = [300, 500, 1000, 1500, 2000, 3000, 4000]

@manipulate for a ∈ 0.1:0.1:1.0, f ∈ freqs
    time_interval = 8e3
    t = 0:1/time_interval:prevfloat(0.5)
    y = @. a * sin(2π * f * t)
    wavplay(y, time_interval)
end
```
