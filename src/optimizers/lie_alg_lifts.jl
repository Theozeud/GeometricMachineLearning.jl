"""
This implements lifts from the base manifold to the Lie algebra.

think about introducing a lift object containing HD and the lifted element of the Lie algebra!!
"""

Ω(Y::StiefelManifold, Δ::AbstractMatrix) = SkewSymMatrix((I - .5*Y*Y')*Δ*Y') 

#this is not very efficient - just used for testing purposes
function global_rep_test(Y::StiefelManifold, Δ::AbstractMatrix)
    B = Ω(Y, Δ)
    #find complement for global section
    N, n = size(Y)
    A = randn(N, N-n)
    A = A - Y*Y'*A
    HD = HouseDecom(A)
    QTB = HD'(B)
    QTBY = QTB*Y 
    B = hcat(vcat(Y'*B*Y, QTBY), vcat(-QTBY', -HD'(QTB')))
    return (HD, B)
end

#does the same as the above function - with the difference in the output format!!!! (no overhead!)
function global_rep_old(Y::StiefelManifold, Δ::AbstractMatrix)
    B = Ω(Y, Δ)
    #find complement for global section
    N, n = size(Y)
    A = randn(N, N-n)
    A = A - Y*Y'*A
    HD = HouseDecom(A)
    QTB = HD'(B)
    B = StiefelLieAlgHorMatrix(SkewSymMatrix(Y'*B*Y), QTB*Y, N, n)
    return (HD, B)
end

function global_rep(Y::StiefelManifold, Δ::AbstractMatrix)
    B = Ω(Y, Δ)
    N, n = size(Y)
    A = rand(N, N-n)
    A = A - Y*Y'*A
    Q = qr(A).Q
    BY = B*Y
    B = StiefelLieAlgHorMatrix(
        SkewSymMatrix(Y'*BY),
        (Q'*BY)[1:N-n,1:n], 
        N, 
        n
    )
    return (Q, B)
end

#this maps from the horizontal part of the Lie algebra to the tangent space of the manifold
function apply_projection_old(Y::StiefelManifold, HD::HouseDecom, B::StiefelLieAlgHorMatrix)
    Y*B.A + HD(B.B)
end

function apply_projection(Y::StiefelManifold, Q::LinearAlgebra.QRCompactWYQ, B::StiefelLieAlgHorMatrix)
    n = size(Y,2)
    Y*B.A + Q*hcat(B.B,zeros(n,n))
end

function apply_λ_old(Y::StiefelManifold, HD::HouseDecom, Y₂::StiefelManifold)
    N, n = size(Y)
    StiefelManifold(Y*(Y₂[1:n, 1:n]) + HD(Y₂[(n+1):N, 1:n]))
end

function apply_λ(Y::StiefelManifold, Q::LinearAlgebra.QRCompactWYQ, Y₂::StiefelManifold)
    N, n = size(Y)
    StiefelManifold(
        Y*(Y₂[1:n, 1:n]) + Q*vcat(Y₂[1+n:N, 1:n], zeros(n, n))
    )
end