#=
$ docker-compose run --rm julia
julia> pwd()
julia> /work
julia> include("experiments/test/runtests.jl")
=#

using Test
using Glob

ignore_files = ["wav_example.md", "clang.md"]

@testset "MyWorkflow.jl" begin
    files = glob("*.md", joinpath(@__DIR__, "..", "notebook")) |> sort
    for f in files
        basename(f) in ignore_files && continue
        @info "Running $f"
        proc = run(`jupytext --to ipynb --execute $f`)
        @test proc.exitcode == 0
    end
end
