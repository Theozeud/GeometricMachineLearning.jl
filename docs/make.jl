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
            "Homogeneous Spaces" => "manifolds/homogeneous_spaces.md",
            "Stiefel" => "manifolds/stiefel_manifold.md",
            "Grassmann" => "manifolds/grassmann_manifold.md",
            ],
        "Arrays" => [
            "Global Tangent Space" => "arrays/stiefel_lie_alg_horizontal.md",
        ],
        "Optimizer Framework" => "Optimizer.md",
        "Optimizer Functions" => [
            "Horizontal Lift" => "optimizers/manifold_related/horizontal_lift.md",
            "Global Sections" => "optimizers/manifold_related/global_sections.md",
            "Retractions" => "optimizers/manifold_related/retractions.md",
            "Adam Optimizer" => "optimizers/adam_optimizer.md",
            ],
        "Special Neural Network Layers" => [
            "Attention" => "layers/attention_layer.md",
            "Multihead Attention" => "layers/multihead_attention_layer.md",
        ],
        "Data Loader" =>[
            "Routines" => "data_loader/data_loader.md",
        ],
        "Tutorials" =>[
            "MNIST" => "../tutorials/mnist_tutorial.md",
        ],
        "Library" => "library.md",
    ],
)

deploydocs(;
    repo   = "github.com/JuliaGNI/GeometricMachineLearning.jl",
    devurl = "latest",
    devbranch = "main",
)
