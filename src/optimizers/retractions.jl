"""
This implements some basic retractions.

TODO: test for Cayley vs Exp
TODO: adapt AT <: StiefelLieAlgHorMatrix for the general case!
"""

#fallback function -> maybe put into another file!
function retraction(::Lux.AbstractExplicitLayer, gx::NamedTuple)
    gx
end

function retraction(::StiefelLayer{Geodesic()}, B::NamedTuple{(:weight, ), Tuple{AT}}) where AT <: StiefelLieAlgHorMatrix
    (weight = geodesic(B.weight),)
end

function retraction(::StiefelLayer{Cayley()}, B::NamedTuple{(:weight, ), Tuple{AT}}) where AT <: StiefelLieAlgHorMatrix
    (weight = cayley(B.weight),)
end

function retraction(::MultiHeadAttention{true, Geodesic()}, B::NamedTuple)
    geodesic(B)
end

function retraction(::MultiHeadAttention{true, Cayley()}, B::NamedTuple)
    cayley(B)
end

geodesic(B::NamedTuple) = apply_toNT(B, geodesic)
function geodesic(B::StiefelLieAlgHorMatrix)
    N, n = B.N, B.n
    E = StiefelProjection(N, n)
    #expression from which matrix exponential and inverse have to be computed
    exponent = hcat(vcat(.5*B.A, .25*B.A^2 - B.B'*B.B), vcat(I(n), .5*B.A))
    StiefelManifold(
        E + hcat(vcat(.5*B.A, B.B), E)*𝔄(exponent)*vcat(I(n), .5*B.A)
    )
end

cayley(B::NamedTuple) = apply_toNT(B, cayley)
function cayley(B::StiefelLieAlgHorMatrix)
    N, n = B.N, B.n
    E = StiefelProjection(N, n)
    exponent = I - .5*hcat(vcat(.5*B.A, .25*B.A^2 - B.B'*B.B), vcat(I(n), .5*B.A))
    StiefelManifold(
        (I + .5*B)*
        (
            E + hcat(vcat(.25*B.A, .5*B.B), vcat(0.5*I(n), zero(B.B)))*(vcat(I(n), 0.5*B.A)/exponent)
            )
    )
end