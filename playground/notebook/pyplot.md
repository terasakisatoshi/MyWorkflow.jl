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
    display_name: Julia 1.5.2
    language: julia
    name: julia-1.5
---

# PyPlot.jl 


```
This module provides a Julia interface to the Matplotlib plotting library from Python, and specifically to the matplotlib.pyplot module.

PyPlot uses the Julia PyCall package to call Matplotlib directly from Julia with little or no overhead (arrays are passed without making a copy).
```

```julia
using Images
using PyPlot
using TestImages
```

> Only the currently documented matplotlib.pyplot API is exported. To use other functions in the module, you can also call matplotlib.pyplot.foo(...) as plt.foo(...). For example, plt.plot(x, y) also works. 

```julia
c = testimage("cameraman") |> channelview |> rawview
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5)) # you can call without `plt` e.g `subplots(1, 2)`
ax1.set_title("cameraman")
ax1.imshow(c, cmap=:gray)
ax2.set_title("hist")
ax2.hist(vec(c), density=true, bins=255);
```

```julia
m = testimage("lena") |> channelview |> rawview
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))
ax1.set_title("lena")
ax1.imshow(permutedims(m, (2, 3, 1)), cmap=:gray)
ax2.set_title("hist")
ax2.hist(vec.([m[1,:,:], m[2,:,:], m[3,:,:]]), density=true, bins=25, color=[:red, :green, :blue]);
```
