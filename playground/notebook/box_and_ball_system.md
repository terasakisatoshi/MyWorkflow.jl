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

# Box and Ball System (BBS)

## References

- [箱玉系の数理](https://mathsoc.jp/meeting/kikaku/2008aki/2008_aki_tokihiro.pdf)
- https://ci.nii.ac.jp/naid/110009579038


## Package のインポート

```julia
using Colors
```

```julia
function case1()
    n=10
    river = zeros(Bool, n)
    river[2]=1
    river[5]=1
    river
end

function case2()
    n=10
    river = zeros(Bool, n)
    river[2]=1
    river[3]=1
    river[5]=1
    river
end

function case3()
    n = 30
    river = zeros(Bool, n)
    river[2]=1
    river[3]=1
    river[4]=1
    
    river[9]=1
    river[10]=1
    
    river[15]=1
    river
end 

```

```julia
river = case1()
```

```julia
findfirst(river)
```

```julia
function evolve!(river::AbstractVector{Bool})
    T = eltype(river)
    n = count(river)
    bs = findall(river)
    negative = .! river
    offset=1
    for i in 1:n
        b = bs[i]
        p = findfirst(negative[b+1:end])
        if !isnothing(p)
            ∅ = p + b
            river[∅] = one(T)
        end
        river[b] = zero(T)
        negative = .! river
    end
    return river
end
```

```julia
river = case1()
expected = Bool[0,0,1,0,0,1,0,0,0,0]
next = evolve!(river)
@assert expected == next "え？ちゃうで？ expected $expected, actual $river"
```

```julia
river = case2()
```

```julia
river = case2()
expected = Bool[0,0,0,1,0,1,1,0,0,0]
next = evolve!(river)
@assert expected == next "え？ちゃうで？ expected $expected, actual $river"
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,1,0,0,1,1,0]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,1,0,0,0,1]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,1,0,0,0]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,1,0,0]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,0,1,0]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,0,0,1]
@assert expected == next
```

```julia
river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,0,0,0]
@assert expected == next
```

```julia
function case4()
    n = 100
    river = zeros(Bool, n)
    river[2]=1
    river[3]=1
    river[4]=1
    
    river[25]=1
    river[26]=1
    
    river[50]=1
    river
end
```

```julia
function play()
    river = case4()
    n = length(river)
    grid=zeros(Bool,n,n)
    for i ∈ 1:n
        IJulia.clear_output(true)
        grid[i,:] = evolve!(river)
        sleep(0.5)
        display(Gray.(.!grid))
    end
end

play()
```
