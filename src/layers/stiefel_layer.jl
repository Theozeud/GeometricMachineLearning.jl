#retraction is more general! function on layer!

struct StiefelLayer{F1, F2} <: ManifoldLayer
    N::Integer
    n::Integer
    retraction::F1
    init_weight::F2
end

function StiefelLayer(N::Integer, n::Integer; init_weight=Lux.glorot_uniform, retraction=Geodesic)
    StiefelLayer{typeof(retraction), typeof(init_weight)}(N, n, retraction, init_weight)
end

function Lux.initialparameters(rng::AbstractRNG, d::StiefelLayer)
    A = d.init_weight(rng, d.N, d.n)
    (weight = StiefelManifold(LinearAlgebra.qr(A).Q[1:d.N, 1:d.n]), )
end

function Lux.initialparameters(::TrivialInitRNG, d::StiefelLayer)
    (weight = zeros(StiefelLieAlgHorMatrix{Float32}, d.N, d.n), )
end

#Lux.initialstates(::AbstractRNG, ::StiefelLayer) = NamedTuple()

Lux.parameterlength(d::StiefelLayer) = d.n*(d.n-1)÷2 + (d.N-d.n)*d.n

Lux.statelength(d::StiefelLayer) = 0

function (d::StiefelLayer)(x::AbstractVecOrMat, ps, st::NamedTuple)
    ps.weight*x, st
end

function retraction(d::StiefelLayer{Geodesic}, B::StiefelLieAlgHorMatrix)
    Exp(B)
end

function retraction(d::StiefelLayer{Geodesic}, B::NamedTuple)
    retraction(d, B.weight)
end