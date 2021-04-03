# -*- coding: utf-8 -*-
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
    display_name: Julia 1.5.3
    language: julia
    name: julia-1.6
---

# Simple Harmonic Motion

```julia
using DifferentialEquations
using Plots
```

<!-- #region -->
質量 $m$ の物体にバネ定数 $k$ のばねが繋がっているとする．この時の物体の変位 $x=x(t)$ についての運動方程式は次のようになる．


\begin{align}
m \ddot{x} = -kx \qquad \ddot{x} = \frac{{d}^2 x}{{d}t^2}
\end{align}

この運動方程式は $x_0 = x(0)$, $v_0 = \dot{x}(0)$ が決まると

$$
x(t) = x_0 \cos\omega t + \frac{v_0}{\omega} \sin\omega t
$$

の形で解が与えられる. ここで $\omega = \sqrt{\frac{k}{m}}$ である.

運動方程式を次のように分解することで１階の連立微分方程式を解くことに帰着させる

\begin{align*}
\dot{x} &= v \\
m \dot{v} &= -kx
\end{align*}

この形の微分方程式を Julia で解くことができる.
<!-- #endregion -->

```julia
function motion(du,u,p,t)
    k, m = p
    du[1] = u[2]
    du[2] = -(k/m) * u[1]
end

x0 = 1.
v0 = 2.
u0 = [x0; v0]
k = 2.
m = 2.
ω = √(k/m)
tspan = (0.0, 2π/ω)
p = [k, m]
prob = ODEProblem(motion, u0, tspan, p)
sol = solve(prob, alg_hints = [:stiff], dt=1/2^10);
```

```julia
E(x, y) = (1/2)*k*x^2 + (1/2)*m*y^2
exact_x(t) = x0 * cos(ω*t) + v0/ω * sin(ω*t)
exact_y(t) = -x0 * ω * sin(ω*t) + v0 * cos(ω*t)

x_range = y_range = range(
    -5, stop = 5, length = 100
)

p = plot(
    aspect_ratio=:equal, 
    xlabel="x", ylabel="v", 
)

plot!(
    exact_x.(sol.t), exact_y.(sol.t), 
    label="exact solution",
    color=:red,
    lw=5,
    alpha=0.5,
)
contour!(x_range, y_range, E)
x = getindex.(sol.u, 1)
y = getindex.(sol.u, 2)
plot!(x, y, label = "Julia-solution", color=:blue, lw=2)
p
```
