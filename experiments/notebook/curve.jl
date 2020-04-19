# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.4.2
#   kernelspec:
#     display_name: Julia 1.4.0
#     language: julia
#     name: julia-1.4
# ---

using Plots
using LaTeXStrings

# # Circle

# +
θ = 0:0.01:2π
x = @. cos(θ)
y = @. sin(θ)

p = plot(
    xlabel = L"x",
    ylabel = L"y",
    xlim = [-1, 1],
    ylim = [-1, 1],
    aspect_ratio = :equal,
)

plot!(p, x, y, label = L"x^2+y^2 = 1")
# -

# # Astroid

# +
θ = 0:0.01:2π
a = 2
x = @. a * cos(θ)^3
y = @. a * sin(θ)^3

eq = latexstring("x^{2/3}+y^{2/3} = $a^{2/3}")

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    xlim = [-2, 2],
    ylim = [-2, 2],
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# # Lissajous

# +
θ = 0:0.01:2π
x = @. sin(θ)
y = @. sin(2θ)

eq = latexstring("y^2=4x^2(1-x^2)")

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    xlim = [-1, 1],
    ylim = [-1, 1],
    aspect_ratio = :equal,
)

plot!(p, x, y, label=false)

# +
θ = -π/4:0.01:π/4

x = @. tan(θ)
y = @. cos(2θ)

eq = L"$y=\frac{1-x^2}{1+x^2}$"

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    xlim = [-1, 1],
    ylim = [0, 1],
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# # Archimedean Spiral

# +
θ = 0:0.01:2π
a = 2
r = @. a*θ
x = @. r * cos(θ)
y = @. r * sin(θ)

eq = L"r=a\theta"

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# # Cardioid 

# +
θ = 0:0.01:2π
a = 2
r = @. a*(1+cos(θ))
x = @. r * cos(θ)
y = @. r * sin(θ)

eq = L"r=a(1+\cos(\theta)"

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# # Rose Curve

# ## n = 2

# +
θ = 0:0.01:2π
a = 2
n = 2
r = @. a*sin(n*θ)
x = @. r * cos(θ)
y = @. r * sin(θ)

eq = latexstring("r=a\\sin($n\\theta)")

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# ## n = 3

# +
θ = 0:0.01:2π
a = 2
n = 3
r = @. a*sin(n*θ)
x = @. r * cos(θ)
y = @. r * sin(θ)

eq = latexstring("r=a\\sin($n\\theta)")

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    aspect_ratio = :equal,
)

plot!(p, x, y, label=false)
# -

# ## n = 4

# +
θ = 0:0.01:2π
a = 2
n = 4
r = @. a*sin(n*θ)
x = @. r * cos(θ)
y = @. r * sin(θ)

eq = latexstring("r=a\\sin($n\\theta)")

p = plot(
    title = eq,
    xlabel = L"x",
    ylabel = L"y",
    aspect_ratio = :equal,
)

plot!(p, x, y, label = :false)
# -

# ## Rose (gif)

# +
θ = 0:0.01:2π
a = 2
anim = @animate for n in 2:10
    r = @. a*sin(n*θ)
    x = @. r * cos(θ)
    y = @. r * sin(θ)

    eq = latexstring("r=a\\sin($n\\theta)")

    p = plot(
        title = eq,
        xlabel = L"x",
        ylabel = L"y",
        xlim=[-3,3],
        ylim=[-3,3],
        aspect_ratio = :equal,
    )

    plot!(p, x, y, label = :false)
end

anim;
# -

gif(anim, "roses.gif", fps=2)
