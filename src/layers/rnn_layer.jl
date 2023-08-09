

mutable struct RNNLayer{M, N, TAO, TAM, TM} <: AbstractExplicitLayer{M, N}
    g₁::TAO     # activation function with respect to output
    g₂::TAM     # activation function with respect to memory
    aₜ₋₁::TM    # memory at the previous step
end

function RNNLayer(m::Int, n::Int, g₁ = identity, g₂ = g₁; allow_fast_activation::Bool=true)
    (g₁, g₂) = allow_fast_activation ? NNlib.fast_act.(g₁, g₂) : (g₁, g₂)
    new{m, n, typeof(g₁), typeof(g₂)}(g₁, g₂)
end

function (layer::RNNLayer)(x::AbstractArray, ps::NamedTuple)
    layer.aₜ₋₁ = layer.g₂(ps.Wₐₐ* layer.aₜ₋₁ + ps.Wₐₒ * x + ps.bₐ)
    layer.g₁(ps.Wₒₐ* layer.aₜ₋₁ + ps.Wₒₒ * x + ps.bₒ)
end

function initialparameters(backend::Backend, ::Type{T}, layer:: RNNLayer{M, N}; init_weight = GlorotUniform(), init_bias = ZeroInitializer(), rng::AbstractRNG = Random.default_rng()) where {M,N,T}
    _Wₐₐ = KernelAbstractions.allocate(backend, T, N, M)
    _Wₐₒ = KernelAbstractions.allocate(backend, T, N, M)
    _Wₒₐ = KernelAbstractions.allocate(backend, T, N, M)
    _Wₒₒ = KernelAbstractions.allocate(backend, T, N, M)
    _bₐ  = KernelAbstractions.allocate(backend, T, N)
    _bₒ  = KernelAbstractions.allocate(backend, T, N)
    init_weight(rng, _Wₐₐ)
    init_weight(rng, _Wₐₒ)
    init_weight(rng, _Wₒₐ)
    init_weight(rng, _Wₒₒ)
    init_bias(rng, bₐ)
    init_bias(rng, bₒ)
    return (Wₐₐ = _Wₐₐ, Wₐₒ = _Wₐₒ, Wₒₐ = _Wₒₐ, Wₒₒ = _Wₒₒ, bₐ = _bₐ, bₒ = _bₒ)
end

function parameterlength(layer::RNNLayer{M,N}) where {M,N}
    return 4*M*N + 2 *N
end