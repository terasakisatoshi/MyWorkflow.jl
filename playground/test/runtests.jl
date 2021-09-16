#=
$ docker-compose run --rm julia
julia> pwd()
julia> /work
julia> include("experiments/test/runtests.jl")
=#

using Test
using Glob
using Base.Threads

ignore_files = ["wav_example.md", "clang.md", "linear_regression.md"]

@testset "MyWorkflow.jl" begin
    files = glob("*.md", joinpath(@__DIR__, "..", "notebook")) |> sort
    @threads for f in files
        basename(f) in ignore_files && continue
        @info "Running $f"
        proc = run(`jupytext --to ipynb --execute $f`)
        @test proc.exitcode == 0
    end
end
