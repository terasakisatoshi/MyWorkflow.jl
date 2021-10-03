---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.13.0
  kernelspec:
    display_name: Julia 1.6.3
    language: julia
    name: julia-1.6
---

```julia
using Plots
using StaticArrays
using Distributions
```

```julia
U = Uniform(0.1, 0.2)

mutable struct Vector2D <: FieldVector{2, Float64}
    x::Float64
    y::Float64
end

function Vector2D()
    v = rand(U)
    vy, vx = v .* sincospi(2rand())
    return Vector2D(vx, vy)
end

mutable struct Point2D <: FieldVector{2, Float64}
    x::Float64
    y::Float64
end
```

```julia
# ofcourse you may add const keyword before each variable.
ymin = -2.
xmin = -2.
ymax = 2.
xmax = 2.
T = 100;
```

```julia
function evolve!(pt::Point2D, v::Vector2D)
    pt .+= v # do not use `pt += v`
    if pt.y ≥ ymax
        pt.y = 2ymax - pt.y 
        v.y = -v.y
    end
    if pt.y ≤ ymin
        pt.y = 2ymin - pt.y 
        v.y = -v.y
    end

    if pt.x ≥ xmax
        pt.x = 2xmax - pt.x 
        v.x = -v.x
    end
    if pt.x ≤ xmin
        pt.x = 2xmin - pt.x 
        v.x = -v.x
    end
    return pt, v
end
```

```julia
pts = [Point2D(rand(2)) for _ in 1:10]
vs = [Vector2D() for _ in 1:10]
anim = @animate for t in 1:T
    IJulia.clear_output(true)
    for (pt, v) in zip(pts, vs)
        evolve!(pt, v)
    end
    s = scatter(getproperty.(pts, :x), getproperty.(pts, :y), 
            size=(400,400),
            xlim=(xmin, xmax), ylim=(ymin, ymax), aspect_ratio=:equal, legend=false
        )
    s |> display
end
```

```julia
gif(anim, "patricles.gif")
```
