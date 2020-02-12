# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.3.3
#   kernelspec:
#     display_name: Julia 1.3.1
#     language: julia
#     name: julia-1.3
# ---

using Plots

# +
plotly()

a=0.5

p = plot3d(xlabel="x",ylabel="y",zlabel="z",xlim=(-1.5,1.5),ylim=(-1.5,1.5))
# Draw slice along xy-plane
us = 0:0.05π:2π
ts = -1:0.05:1

for t in -1:0.05:1
    x=@. (t^2+a)*cos(us)
    y=@. (t^2+a)*sin(us)
    z=t*ones(length(x))
    plot3d!(p, x,y,z,label="",color=:blue)
end

for u in us
    x = @. (ts^2+a)*cos(u)
    y = @. (ts^2+a)*sin(u)
    z = ts
    plot3d!(p, x,y,z,label="",color=:blue)
end

display(p)

# +
gr()

as = hcat(reverse(0.0:0.01:0.5), 0.0:0.01:0.5)

anim=@animate for a in as
    IJulia.clear_output(true)
    p = plot3d(xlabel="x",ylabel="y",zlabel="z",xlim=(-1.5,1.5),ylim=(-1.5,1.5))
    # Draw slice along xy-plane
    us = 0:0.05π:2π
    ts = -1:0.05:1

    for t in -1:0.05:1
        x=@. (t^2+a)*cos(us)
        y=@. (t^2+a)*sin(us)
        z=t*ones(length(x))
        plot3d!(p, x,y,z,label="",color=:blue)
    end

    for u in us
        x = @. (ts^2+a)*cos(u)
        y = @. (ts^2+a)*sin(u)
        z = ts
        plot3d!(p, x,y,z,label="",color=:blue)
    end
    p |> display
end
# -

gif(anim)
