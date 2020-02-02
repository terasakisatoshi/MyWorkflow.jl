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

print("Hello world")

using Plots

# # Rapid Visualization on Jupyter
#
# Just `add IJulia.clear_output(true)` and display `p` plot object simultaneously will improve your visualizatoin life

ps=[]
for t in 1:0.1:10
    IJulia.clear_output(true)
    p = plot(x-> sin(x+t))
    p |> display
    push!(ps, p)
end

# # Dump result as tmp.gif

@gif for p in ps
    plot(p)
end
