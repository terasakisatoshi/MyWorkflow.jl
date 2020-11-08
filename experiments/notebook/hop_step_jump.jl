# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.6.0
#   kernelspec:
#     display_name: Julia 1.5.2
#     language: julia
#     name: julia-1.5
# ---

# # Linear programming using Julia

# - Let's consider a function of two variables $f=f(x,y)$ defined by
#     
# $$
#     f(x,y) = 5x + 3y.
# $$
#
# - We would like find $(x,y)=(\hat{x}, \hat{y})$ that maximize the value of f(x,y) with the following contstraits, namely:
#
# $$
# \begin{aligned}
# \text{maximize} &\ f(x,y) \\
# \text{subject to}:&\ 0\leq x \leq 2, \\
#                   &\ 0\leq y \leq 30, \\
#                   &\ 5x + 3y \leq 3.
# \end{aligned}
# $$
#
# - Can we solve this problem using Julia ? Let's find out.

# - JuMP is a domain-specific modeling language for mathematical optimization embedded in Julia.
# - Tulip is an open-source interior-point solver for linear optimization, written in pure Julia.

# ## Load Packages

using JuMP
import Tulip
using LazySets
using Plots
using LaTeXStrings
using Colors

# Models are created with the Model function. The following example adopts `Tulip` as a solver. Note that the version of JuMP should be $\geq 0.21$

]st JuMP

model = Model(Tulip.Optimizer)

# The following commands will create two variables, `x` and `y`, with both lower and upper bounds.

xmin, xmax = 0, 2
ymin, ymax = 0, 30
# you can use `≤` instead of `<=`
@variable(model, xmin ≤ x ≤ xmax)
@variable(model, ymin ≤ y ≤ ymax);

# Next we'll set our objective. Note again the model, so we know which model's objective we are setting! The objective sense, `Max` or `Min`, should be provided as the second argument. Note also that we don't have a multiplication * symbol between 5 and our variable `x` - Julia is smart enough to not need it! 

f(x,y)=5x+3y
@objective(model, Max, 5x+3y)

# Adding constraints is a lot like setting the objective. Here we create a less-than-or-equal-to constraint using `<=`, but we can also create equality constraints using `==` and greater-than-or-equal-to constraints with `>=`

@constraint(model, con, 1x + 5y <= 3)

# ## Summarize model

# Let's see the summary of our `model`. The result should be equivalent to the condition:
#
# $$
# \begin{aligned}
# \text{maximize} &\ f(x,y) \\
# \text{subject to}:&\ 0\leq x \leq 2, \\
#                   &\ 0\leq y \leq 30, \\
#                   &\ 5x + 3y \leq 3.
# \end{aligned}
# $$

model

# - It's time to solve the model using `JuMP.optimize!`:

optimize!(model)

# Done! 

# ## Output the result

# We can access the solution via `objective_value` and `value` function.

x̂ = value(x)
ŷ = value(y)
@assert f̂ = objective_value(model) ≈ f(x̂, ŷ)
@show x̂, ŷ

# # Visualize result

# - Let's visualize the constraint $x+5y\leq 3$. It can be written as $\langle[1,5],[x,y]\rangle\leq 3$ where $\langle\bullet,\bullet\rangle$ stands for inner product of 2-dimensional Euclidian space. LazySets provides a recipe that visualize the half plane of the form $\langle a,x\rangle \leq b$ via `LazySets.HalfSpace(a,b)`.
# - Note that the version of LazySets should be >= 0.35

p = plot(xlims=[xmin, xmax], ylims=[ymin, ymax])
hs = HalfSpace([1.,5.], 3.)
p = plot!(p, hs)
hp = Hyperplane([1.,5.], 3.)
p = plot!(p, hp,color=:red)

# Where is the solution, say, $(\hat{x},\hat{y})$ ?

scatter!(p, [x̂], [ŷ])

# # Linear programming with multiple constraits

# - Again, let's consider a function of two variables $f(x,y)=5x+3y$. 
# - We would like find $(x,y)=(\hat{x}, \hat{y})$ that maximize the value of $f(x,y)$ with the following multiple linear contstraits, namely:
#
# $$
# \begin{aligned}
# \text{maximize} &\ f(x,y)=3x+5y, \\
# \text{subject to}:&\ 
#     \begin{bmatrix}
#         2 & 2 \\
#         2 & -4 \\
#         -2 & 1 \\
#         0 & -1 \\
#         0 & 1
#     \end{bmatrix}
#     \begin{bmatrix} x \\ y \end{bmatrix}
#     \leq 
#     \begin{bmatrix}
#         33 \\
#         8 \\
#         -5 \\
#         -1 \\
#         8
#     \end{bmatrix}.
# \end{aligned}
# $$
#
# - This condition is taken from [MML book](https://mml-book.github.io/) p240 Example 7.5. Note that the original example has a typo. See https://github.com/mml-book/mml-book.github.io/issues/547
# - Can we solve this problem using Julia ? Of course.

# ## Define model and constraits

# +
f(x,y)=5x+3y
model = Model(Tulip.Optimizer)

@variable(model, x)
@variable(model, y)

@objective(model, Max, f(x,y))

X=Float64[
    2   2
    2  -4
    -2  1
    0  -1
    0   1
]

bs = Float64[
    33 
    8
    -5 # MML book has typo. I've fixed from 5 to -5
    -1
    8
]

@constraint(model, con, X * [x,y] .≤ bs)
# -

# ## Optimize model

optimize!(model)

f̂=objective_value(model)
x̂=value(x)
ŷ=value(y)
@show x̂, ŷ

# ## Visualize result

# +
p = plot(xlim=[0,16], ylim=[0,10], aspect_ratio=:equal, ticks=0:2:16)
hs = HalfSpace{Float64, Vector{Float64}}[]
hp = Hyperplane{Float64, Vector{Float64}}[]

cs = distinguishable_colors(length(bs))
for (i, b) in zip(1:size(X)[1], bs)
    push!(hs, HalfSpace(X[i, 1:2], b))
    push!(hp, Hyperplane(X[i,1:2], b))
end

ph = HPolyhedron(hs)
plot!(p, convert(HPolytope, ph))
plot!.(Ref(p), hp)
scatter!(p, [x̂], [ŷ], label=L"(\hat{x}, \hat{y})", marker=:star, msize=8)
xs = 0:0.01:16
ys = 0:0.01:10
contour!(p, xs, ys, f)
# -

# # References:
#
# - JuMP quick start: https://jump.dev/JuMP.jl/v0.21.3/quickstart/
