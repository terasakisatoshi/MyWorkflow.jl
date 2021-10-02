---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.13.0
  kernelspec:
    display_name: Julia 1.6.3
    language: julia
    name: julia-1.6
---

```julia
using StaticArrays
abstract type AbstractPoint{N,T} <: StaticVector{N,T} end
# abstract type AbstractPoint{N,T} <: AbstractVector{T} end

Base.size(p::AbstractPoint{N,T}) where {N,T} = (length(p),)
Base.length(::AbstractPoint{N,T}) where {N,T} = N

struct Point{N,T} <: AbstractPoint{N,T}
    data::NTuple{N,T}
end

function Base.getindex(p::Point{N,T}, i::Int) where {N,T}
    return p.data[i]
end

# outer constructors
(::Type{P})(x::AbstractVector) where {P <: AbstractPoint} = P(Tuple(x))
(::Type{P})(x...) where {P <: AbstractPoint} = P(x)

function promote_tuple_eltype(::Union{T,Type{T}}) where T <: Tuple
    t = reduce(promote_type, T.parameters)
    return t
end

function Point(x::T) where {N,T <: Tuple{Vararg{Any,N}}}
    return Point{N,promote_tuple_eltype(T)}(x)
end

function Point{N}(x::T) where {N,T <: Tuple}
    Point{N,promote_tuple_eltype(T)}(x)
end

Point(p::Point{N,T}) where {N,T} = Point{N,T}(p.data)

const Point2{T} = Point{2,T}
const Point3{T} = Point{3,T}

Base.getproperty(p::AbstractPoint{2,T}, ::Val{:x}) where {T} = p[1]
Base.getproperty(p::AbstractPoint{2,T}, ::Val{:y}) where {T} = p[2]

Base.getproperty(p::AbstractPoint{3,T}, ::Val{:x}) where {T} = p[1]
Base.getproperty(p::AbstractPoint{3,T}, ::Val{:y}) where {T} = p[2]
Base.getproperty(p::AbstractPoint{3,T}, ::Val{:z}) where {N,T} = p[3]

Base.getproperty(p::AbstractPoint{N,T}, ::Val{:data}) where {N,T} = getfield(p, :data)
Base.getproperty(p::AbstractPoint{N,T}, s::Symbol) where {N,T} = getproperty(p, Val(s))
```

```julia
p1 = Point(2,3)
p2 = Point(3,4)
@show p1 + p2
```
