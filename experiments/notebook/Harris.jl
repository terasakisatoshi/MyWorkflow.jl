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

# + active=""
# # Harris Corner Detector
#
# - [実践 コンピュータビジョン](https://www.oreilly.co.jp/books/9784873116075/)
# - https://en.wikipedia.org/wiki/Harris_Corner_Detector
# - https://www.researchgate.net/publication/299711769_Revisiting_Harris_Corner_Detector_Algorithm_A_Gradual_Thresholding_Approach
# - [解説コンピュータビジョンのための 画像の特徴点の抽出](http://www.iim.cs.tut.ac.jp/~kanatani/papers/harris.pdf)
# -

using Images
using TestImages
using ImageShow
using ImageFiltering

img = testimage("c")

typeof(img), eltype(img)

# +
# img = testimage("jetplane")
# img = Gray.(img) # GrayA to Gray
# -

imfilter(img, 8 .* Kernel.sobel())

∂x, ∂y = 8 .* Kernel.sobel()

Ix = imfilter(img, ∂x)

Iy = imfilter(img, ∂y)

Iy.^2.

# ## Calculate Harris response

# +
#= 
W = [Wxx Wxy
     Wxy Wyy]y
  = G * I
where G * I is the convolution between Gauss Operator G and I 
I = [Ix^2  IxIy
    IyIx  Iy^2]
  = [Ix * [Ix Iy]
    Iy] =#

σ = 3.

Wxx = imfilter(Ix.^2., Kernel.gaussian([σ,σ], [3,3]))
Wyy = imfilter(Iy.^2., Kernel.gaussian([σ,σ], [3,3]))
Wyx = Wxy = imfilter(Ix .* Iy, Kernel.gaussian([σ,σ], [3,3]))

detW = @. Wxx * Wyy - Wxy * Wyx
trW = @. Wxx + Wyy
κ = detW ./ trW
# -

thresh = 0.08
corner_thresh = maximum(κ) * thresh
iscorner = 1. .* (κ .> corner_thresh)
colorview(Gray, iscorner)

# # Apply NMS (Non maximum suppression)

# +
mindist = 10
indices_ = sortperm(κ[:], rev=true) # reshape Mat to Vector
indices = Int[]
for i in indices_
    if κ[i] > corner_thresh
        push!(indices, i)
    end
end

indices;
# -

loc = ones(Bool, img |> size)
H, W = img |> size
valids = zeros(img |> size)
for i in indices
    ix = min(div(i, H) + 1, W)
    iy = min(rem(i, H) + 1, H)
    if loc[iy, ix] == true
        valids[iy, ix] = 1
        for s in -mindist:mindist
            for t in -mindist:mindist
                if 1 <= iy + s <= H && 1 <= ix + t <= W
                    loc[iy + s, ix + t] = false
                end
            end
        end
    end
end

colorview(Gray, hcat(channelview(img), valids))
