module GeometricMachineLearning

    using BandedMatrices
    using Distances
    using LinearAlgebra
    using NNlib
    using ProgressMeter
    using Random
    using Zygote
    using StatsBase


    include("gradient.jl")
    include("training.jl")

    include("activations/abstract_activation_function.jl")
    include("activations/identity_activation.jl")

    export SymmetricMatrix, SymplecticMatrix

    include("arrays/add.jl")
    include("arrays/zero_vector.jl")
    
    include("arrays/block_identity_lower.jl")
    include("arrays/block_identity_upper.jl")
    include("arrays/symmetric2.jl")
    include("arrays/symplectic.jl")
    include("arrays/symplectic_lie_alg2.jl")
    include("arrays/sympl_lie_alg_hor.jl")

    export AbstractLayer
    export FeedForwardLayer, LinearFeedForwardLayer
    export Gradient
    export Linear
    export ResidualLayer
    export LinearSymplecticLayerP, LinearSymplecticLayerQ
    export SymplecticStiefelLayer

    include("layers/abstract_layer.jl")
    include("layers/feed_forward_layer.jl")
    include("layers/gradient.jl")
    include("layers/linear.jl")
    include("layers/residual_layer.jl")
    include("layers/linear_symplectic_layer.jl")
    include("layers/manifold_layer.jl")
    include("layers/symplectic_stiefel_layer.jl")


    export AbstractNeuralNetwork

    include("architectures/architectures.jl")
    include("backends/backends.jl")

    export LuxBackend

    include("backends/lux.jl")

    # set default backend in NeuralNetwork constructor
    NeuralNetwork(arch::AbstractArchitecture; kwargs...) = NeuralNetwork(arch, LuxBackend(); kwargs...)

    export NeuralNetwork
    export HamiltonianNeuralNetwork
    export SympNet
    export LASympNet
    export GSympNet

    include("architectures/autoencoder.jl")
    include("architectures/fixed_width_network.jl")
    include("architectures/hamiltonian_neural_network.jl")
    include("architectures/variable_width_network.jl")
    include("architectures/sympnet.jl")

    export train!, apply!, jacobian!
    export Iterate_Sympnet

    include("optimizers/abstract_optimizer_cache.jl")
    include("optimizers/abstract_optimizer.jl")
    include("optimizers/momentum_optimizer_cache.jl")
    include("optimizers/standard_optimizer.jl")
    #include("optimizers/adam_optimizer.jl")
    include("optimizers/momentum_optimizer.jl")

    export StandardOptimizer
    #export AdamOptimizer
    export MomentumOptimizer
    
    export setup_Optimiser!
    #export AbstractOptimizerCache
    export MomentumOptimizerLayerCache
    export MomentumOptimizerCache

    export apply!
    export check_symplecticity
    export riemannian_gradient
    export horizontal_lift
    #export init
    #export init_adam
    #export init_momentum

end
