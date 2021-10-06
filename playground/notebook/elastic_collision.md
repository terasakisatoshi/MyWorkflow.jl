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

# Elastic_collision

- https://en.wikipedia.org/wiki/Elastic_collision

```julia
using LinearAlgebra

using Plots
using StaticArrays
using Distributions
```

```julia
U = Uniform(0.1, 0.2)

mutable struct Velocity2D <: FieldVector{2, Float64}
    x::Float64
    y::Float64
end

function Velocity2D()
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
struct Circle
    pt::Point2D
    v::Velocity2D
    r::Float64
    m::Float64
end
```

```julia
# ofcourse you may add const keyword before each variable.
ymin = -2.
xmin = -2.
ymax = 2.
xmax = 2.
T = 300;
```

```julia
function evolve!(pt::Point2D, v::Velocity2D)
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

function move!(pt::Point2D, v::Velocity2D, r::Real=0)
    pt .+= v # do not use `pt += v`
    if pt.y  ≥ ymax - r
        pt.y = 2(ymax - r)- pt.y 
        v.y = -v.y
    end
    if pt.y ≤ (ymin + r)
        pt.y = 2(ymin + r) - pt.y 
        v.y = -v.y
    end

    if pt.x ≥ (xmax - r)
        pt.x = 2(xmax - r) - pt.x 
        v.x = -v.x
    end
    if pt.x ≤ (xmin + r)
        pt.x = 2(xmin + r) - pt.x 
        v.x = -v.x
    end
    return pt, v
end

function move!(c::Circle)
    move!(c.pt, c.v, c.r)
end
```

```julia
function drawcircle(pt, r)
    θ = 0:0.1:2π+0.1
    x = @. pt.x + r * cos(θ)
    y = @. pt.y + r * sin(θ)
    p = plot(
        x, y, 
        color=:blue, 
        linecolor=:black, 
        fillalpha=0.2, 
        legend=false,
        seriestype=[:shape], 
        lw=0.5
    )
    p
end
```

```julia
dist(pt1, pt2) = sqrt((pt1.x - pt2.x)^2 + (pt1.y - pt2.y)^2)
has_contact(c1, c2) = c1.r + c2.r ≥ dist(c1.pt, c2.pt)
```

```julia
function main(disp::Bool=false)
    circles = Circle[]
    num_circles = 10
    while length(circles) != num_circles
        θ = 2π*rand()
        v_abs = 0.08
        v = Velocity2D(v_abs * cos(θ), v_abs * sin(θ))
        m = r = rand(Uniform(0.1, 0.3))
        x = rand(Uniform(xmin+r, xmax-r))
        y = rand(Uniform(ymin+r, ymax-r))
        
        c = Circle(
            Point2D(x, y),
            v,
            r,
            m,
        )
        c_plus_r = Circle(
            Point2D(x, y),
            v,
            r + v_abs,
            m,
        )
        any(has_contact.(Ref(c_plus_r), circles)) && continue
        push!(circles, c)
    end

    anim = @animate for t in 1:T
        disp && IJulia.clear_output(true)
        p = plot(aspect_ratio=true, legend=false)
        move!.(circles)
        # naive collision algorithm
        for i in 1:length(circles)
            for j in (i+1):length(circles)
                c1 = circles[i]
                c2 = circles[j]
                # update c1.v and c2.v
                if has_contact(c1, c2)
                    pt1 = c1.pt
                    v1 = c1.v
                    m1 = c1.m

                    pt2 = c2.pt
                    v2 = c2.v
                    m2 = c2.m
                    
                    # correct position so that c1 and c2 does not contact
                    for _ in 0:0.01:1
                        c1.pt .-= 0.01 .* v1
                        c2.pt .-= 0.01 .* v2
                        if c1.r + c2.r < dist(c1.pt, c2.pt)
                            break
                        end
                    end

                    v1_next = v1 - 2m2/(m1+m2) * dot(v1 - v2, pt1 - pt2) * (pt1-pt2)/dot(pt1-pt2, pt1-pt2)
                    v2_next = v2 - 2m1/(m2+m1) * dot(v2 - v1, pt2 - pt1) * (pt2-pt1)/dot(pt2-pt1, pt2-pt1)

                    c1.v .= v1_next
                    c2.v .= v2_next

                end
            end
        end

        s = plot(
            size=(400, 400),
            xlim=(xmin, xmax), ylim=(ymin, ymax), 
            aspect_ratio=:equal, legend=false,
        )
        
        for c in circles
            pt = c.pt
            r = c.r
            θ = 0:0.1:2π+0.1
            x = @. pt.x + r * cos(θ)
            y = @. pt.y + r * sin(θ)
            plot!(
                s,
                x, y, 
                color=:blue, 
                linecolor=:black, 
                fillalpha=0.2, 
                legend=false,
                seriestype=[:shape], 
                lw=0.5
            )
        end
        plot!(s, title="$t")
        disp && display(s)
    end
    return anim
end
```

```julia
gif(main(), "goma.gif")
```
