"""
This implements some basic retractions.


TODO: test for Cayley vs Exp
TODO: adapt AT <: StiefelLieAlgHorMatrix for the general case!
"""

#fallback function -> maybe put into another file!
function retraction(::Lux.AbstractExplicitLayer, gx::NamedTuple)
    gx
end

function retraction(::StiefelLayer{Geodesic}, B::NamedTuple)
    geodesic(B)
end

function retraction(::StiefelLayer{Cayley}, B::NamedTuple)
    geodesic(B)
end

function retraction(::GrassmannLayer{Geodesic}, B::NamedTuple)
    geodesic(B)
end

function retraction(::PSDLayer{inverse, Geodesic}, B::NamedTuple) where {inverse}
    geodesic(B)
end

function retraction(::PSDLayer{inverse, Cayley}, B::NamedTuple) where {inverse}
    cayley(B)
end

function retraction(::MultiHeadAttention{true, Geodesic}, B::NamedTuple)
    geodesic(B)
end

function retraction(::MultiHeadAttention{true, Cayley}, B::NamedTuple)
    cayley(B)
end

geodesic(B::NamedTuple) = apply_toNT(B, geodesic)

function geodesic(B::StiefelLieAlgHorMatrix{T}) where T
    N, n = B.N, B.n
    E = StiefelProjection(N, n, T)
    #expression from which matrix exponential and inverse have to be computed
    unit = One(n, T)
    exponent = hcat(vcat(T(.5)*B.A, T(.25)*B.A^2 - B.B'*B.B), vcat(unit, T(.5)*B.A))
    StiefelManifold(
        E + hcat(vcat(T(.5)*B.A, B.B), E)*𝔄(exponent)*vcat(unit, T(.5)*B.A)
    )
end

function geodesic(B::GrassmannLieAlgHorMatrix{T}) where T
    N, n = B.N, B.n
    E = StiefelProjection(N, n, T)
    #expression from which matrix exponential and inverse have to be computed
    unit = One(n, T)
    exponent = hcat(vcat(zeros(T, n, n), - B.B'*B.B), vcat(unit, zeros(T, n, n)))
    GrassmannManifold(
        E + (hcat(vcat(zeros(T, n, n), B.B), E)*𝔄(exponent))[1:N, 1:n]
    )
end

cayley(B::NamedTuple) = apply_toNT(B, cayley)
function cayley(B::StiefelLieAlgHorMatrix{T}) where T
    N, n = B.N, B.n
    E = StiefelProjection(N, n, T)
    unit = One(n, T)
    unit2 = One(2*n, T)
    exponent = unit2 - T(.5)*hcat(vcat(T(.5)*B.A, T(.25)*B.A^2 - B.B'*B.B), vcat(unit, T(.5)*B.A))
    StiefelManifold(
        (One(N, T) + T(.5)*B)*
        (
            E + hcat(vcat(T(.25)*B.A, T(.5)*B.B), vcat(T(0.5)*unit, zero(B.B)))*(exponent \ vcat(unit, T(0.5)*B.A))
            )
    )
end