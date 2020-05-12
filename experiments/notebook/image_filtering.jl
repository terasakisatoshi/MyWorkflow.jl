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

using ImageFiltering
using TestImages
using ImageShow # to display images clearly

c = testimage("c")
c 

diff1,diff2 = Kernel.prewitt()
println(1/6) # 0.166666
display(diff1)
display(diff2)

c = testimage("c")
imfilter(c, 6. .* Kernel.prewitt())

diff1,diff2 = Kernel.sobel()
println(1/8) # 0.125
display(diff1)
display(diff2)

c = testimage("c")
imfilter(c, 8. .* Kernel.prewitt())
