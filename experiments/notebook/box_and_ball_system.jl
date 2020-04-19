# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.4.2
#   kernelspec:
#     display_name: Julia 1.4.0
#     language: julia
#     name: julia-1.4
# ---

# # Box and Ball System (BBS)
#
# ## References
#
# - [箱玉系の数理](https://mathsoc.jp/meeting/kikaku/2008aki/2008_aki_tokihiro.pdf)
# - https://ci.nii.ac.jp/naid/110009579038

# ## Package のインポート

using Colors

# +
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

# -

river = case1()

findfirst(river)

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

river = case1()
expected = Bool[0,0,1,0,0,1,0,0,0,0]
next = evolve!(river)
@assert expected == next "え？ちゃうで？ expected $expected, actual $river"

river = case2()

river = case2()
expected = Bool[0,0,0,1,0,1,1,0,0,0]
next = evolve!(river)
@assert expected == next "え？ちゃうで？ expected $expected, actual $river"

river = case2()
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,1,0,0,1,1,0]
@assert expected == next

river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,1,0,0,0,1]
@assert expected == next

river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,1,0,0,0]
@assert expected == next

river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,1,0,0]
@assert expected == next

river = case2()
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
next = evolve!(river)
expected = Bool[0,0,0,0,0,0,0,0,1,0]
@assert expected == next

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

# +
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
