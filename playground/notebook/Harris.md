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
    display_name: Julia 1.6.0
    language: julia
    name: julia-1.6
---

<!-- #raw -->
# Harris Corner Detector

- [実践 コンピュータビジョン](https://www.oreilly.co.jp/books/9784873116075/)
- https://en.wikipedia.org/wiki/Harris_Corner_Detector
- https://www.researchgate.net/publication/299711769_Revisiting_Harris_Corner_Detector_Algorithm_A_Gradual_Thresholding_Approach
- [解説コンピュータビジョンのための 画像の特徴点の抽出](http://www.iim.cs.tut.ac.jp/~kanatani/papers/harris.pdf)
<!-- #endraw -->

```julia
using Images
using TestImages
using ImageShow
using ImageFiltering
```

```julia
img = testimage("c")
```

```julia
typeof(img), eltype(img)
```

```julia
# img = testimage("jetplane")
# img = Gray.(img) # GrayA to Gray
```

```julia
imfilter(img, 8 .* Kernel.sobel())
```

```julia
∂x, ∂y = 8 .* Kernel.sobel()
```

```julia
Ix = imfilter(img, ∂x)
```

```julia
Iy = imfilter(img, ∂y)
```

```julia
Iy.^2.
```

## Calculate Harris response

```julia
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
```

```julia
thresh = 0.08
corner_thresh = maximum(κ) * thresh
iscorner = 1. .* (κ .> corner_thresh)
colorview(Gray, iscorner)
```

# Apply NMS (Non maximum suppression)

```julia
mindist = 10
indices_ = sortperm(κ[:], rev=true) # reshape Mat to Vector
indices = Int[]
for i in indices_
    if κ[i] > corner_thresh
        push!(indices, i)
    end
end

indices;
```

```julia
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
```

```julia
colorview(Gray, hcat(channelview(img), valids))
```
