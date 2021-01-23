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

```julia
using ImageFiltering
using TestImages
using ImageShow # to display images clearly
```

```julia
c = testimage("c")
c 
```

```julia
diff1, diff2 = Kernel.prewitt()
println(1 / 6) # 0.166666
display(diff1)
display(diff2)
```

```julia
c = testimage("c")
imfilter(c, 6. .* Kernel.prewitt())
```

```julia
diff1, diff2 = Kernel.sobel()
println(1 / 8) # 0.125
display(diff1)
display(diff2)
```

```julia
c = testimage("c")
imfilter(c, 8. .* Kernel.prewitt())
```
