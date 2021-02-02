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
using Plots; gr(color=:black)
using Interact
using LaTeXStrings
```

```julia
@manipulate for θ ∈ 0:0.01:π
    p = plot(aspect_ratio=:equal, legend=false, title="θ = $(round(θ,digits=3))")

    ux, uy = Plots.unzip(Plots.partialcircle(0, θ, 10, 0.2))
    
    ann_rad = 0.3
    plot!(t->t*cos(θ), t->t*sin(θ), 0, 1)
    plot!(t->cos(θ), identity, 0, sin(θ), linestyle=:dash)
    plot!(identity, t-> sin(θ), 0, cos(θ), linestyle=:dash)
    
    scatter!([cos(θ)], [sin(θ)])
    scatter!([cos(θ)], [0])
    scatter!([0], [sin(θ)])

    annotate!((ann_rad* cos(θ/2), ann_rad* sin(θ/2), 
            Plots.text(L"\theta", 16, :center))
    )
    annotate!((cos(θ), -0.1, Plots.text(L"\cos\theta", 16, :up)))
    annotate!((0, sin(θ)+0.05, Plots.text(L"\sin\theta", 16, :bottom)))
    
    plot!(ux, uy, linestyle=:dash)
    plot!(cos, sin, 0, 2π)
    p
end
```
