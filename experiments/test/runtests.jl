#=
$ docker-compose run --rm julia
julia> pwd()
julia> /work
julia> include("experiments/test/runtests.jl")
=#

using Test
using Glob

@testset "MyWorkflow.jl" begin
    files = glob("*.md", joinpath(@__DIR__, "..", "notebook")) |> sort
    for f in files
        basename(f) == "wav_example.md" && continue
        @info "Running $f"
        proc = run(`jupytext --to ipynb --execute $f`)
        @test proc.exitcode == 0
    end
end
