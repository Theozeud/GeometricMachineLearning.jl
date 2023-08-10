using GeometricMachineLearning
using Documenter


makedocs(;
    modules=[GeometricMachineLearning],
    authors="Michael Kraus, Benedikt Brantner",
    repo="https://github.com/JuliaGNI/GeometricMachineLearning.jl/blob/{commit}{path}#L{line}",
    sitename="GeometricMachineLearning.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://juliagni.github.io/GeometricMachineLearning.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "Architectures" => [
            "SympNet" => "architectures/sympnet.md",
        ],
        "Manifolds" => [
            "Grassmann" => "manifolds/grassmann_manifold.md",
            "Stiefel" => "manifolds/stiefel_manifold.md",
            ],
        "Library" => "library.md",
    ],
)

deploydocs(;
    repo   = "github.com/JuliaGNI/GeometricMachineLearning.jl",
    devurl = "latest",
    devbranch = "main",
)
