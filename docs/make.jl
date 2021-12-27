using DAMMmodel
using Documenter

makedocs(;
    modules=[DAMMmodel],
    authors="Alexis Renchon et al.",
    repo="https://github.com/CUPofTEAproject/DAMMmodel.jl/blob/{commit}{path}#L{line}",
    sitename="DAMMmodel.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://CUPofTEAproject.github.io/DAMMmodel.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/CUPofTEAproject/DAMMmodel.jl.git",
)
