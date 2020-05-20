# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.4.2
#   kernelspec:
#     display_name: Julia 1.4.1
#     language: julia
#     name: julia-1.4
# ---

print("Interact Sample")

using Interact
using Plots
using Rotations

# +
function f(a)
    xs = -pi:0.01:pi
    ys = @. sin(xs - a)
    plot(xs, ys)
end

a_slider=slider(-3:0.1:3,value=0.2, label="a_slider")
p=map(f, observe(a_slider))
map(display,[a_slider, p])
# +
p=ones(3)/sqrt(3)
scatter3d(
    [p[1]],[p[2]],[p[3]],
    xlabel="x",ylabel="y",zlabel="z",
    color=:blue
)

function plot_rotated_pts(x_angle,y_angle,z_angle)
    xyz_rad = deg2rad.([x_angle,y_angle,z_angle])
    r=RotXYZ(xyz_rad...)
    q=r*p
    scatter3d!([q[1]],[q[2]],[q[3]],color=:green,legend=false)
    xlims!((-1.0,1.0)); ylims!((-1.0,1.0)); zlims!((-1.0,1.0))
end

x_axis=slider(-180:180, label="x_axis")
y_axis=slider(-180:180, label="y_axis")
z_axis=slider(-180:180, label="z_axis")

angle_plot=map(
    (x_deg,y_deg,z_deg)->plot_rotated_pts(x_deg,y_deg,z_deg),
    map(observe, [x_axis,y_axis,z_axis])...,
)
    #observe(x_axis),observe(y_axis),observe(z_axis)

map(display,[x_axis, y_axis, z_axis, angle_plot]);
