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
    name: julia-1.6
---

```julia
using Luxor
```

```julia
using Luxor

@png begin
    len = 180
    sethue("purple")
    sector(Point(O.x - len/2, O.y), 0, len, 5pi/3, 0, :fill)
    sector(Point(O.x + len/2, O.y), 0, len, pi, pi+pi/3, :fill)
    sector(Point(O.x, O.y - len * √3/2), 0, len, pi/3, pi/3 + pi/3, :fill)
    clipreset()
    
    sethue("orange")
    
    △ = Point[Point(-len/2, 0), Point(len/2, 0), Point(0, -√3/2*len)]
    setline(2)
    poly(△,  :stroke, close=true)
end
```

```julia

```
