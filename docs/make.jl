using MyWorkflow
using Documenter

makedocs(;
    modules=[MyWorkflow],
    authors="Satoshi Terasaki <terasakisatoshi.math@gmail.com>",
    repo="https://github.com/terasakisatoshi/MyWorkflow.jl/blob/{commit}{path}#L{line}",
    sitename="MyWorkflow.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://terasakisatoshi.github.io/MyWorkflow.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/terasakisatoshi/MyWorkflow.jl",
)
