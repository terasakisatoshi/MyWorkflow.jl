---
jupyter:
  jupytext:
    encoding: '# -*- coding: utf-8 -*-'
    formats: jl,md
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.11.4
  kernelspec:
    display_name: Julia 1.6.1
    language: julia
    name: julia-1.6
---

```julia
using DifferentialEquations
using Plots
```

```julia
function freefall(du,u,p,t)
    g = p[1]
    du[1] = u[2]
    du[2] = -g
end

x0 = 10.
v0 = 4.
g = 9.8
u0 = [x0; v0]
tspan = (0.0, 1.)
p = [g] # 重力加速度
prob = ODEProblem(freefall, u0, tspan, p)
sol = solve(prob);
```

```julia
p = plot(sol, vars=(1))
plot!(
    t -> -0.5 * g * t^2 + v0*t + x0, 
    xlims=tspan,
    linestyle=:dash,
    size=(1000, 1000),
)
```
