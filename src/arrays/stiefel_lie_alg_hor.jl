"""
This implements the horizontal component of the Lie algebra (in this case just the skew-symmetric matrices).
The projection is: 
S -> SE where 
|I|
|0| = E.

An element of StiefelLieAlgMatrix takes the form: 
| A -B'|
| B  0 | where A is skew-symmetric.

This also implements the projection: 
| A -B'|    | A -B'|
| B  D | -> | B  0 |.
"""

mutable struct StiefelLieAlgHorMatrix{T, AT <: SkewSymMatrix{T}, ST <: AbstractMatrix{T}} <: AbstractMatrix{T}
    A::AT
    B::ST
    N::Int
    n::Int 

    function StiefelLieAlgHorMatrix(A::SkewSymMatrix, B::AbstractMatrix)
        n = A.n 
        N = size(B)[1] + n
        @assert size(B)[2] == n
        @assert eltype(A) == eltype(B)

        new{eltype(A), typeof(A), typeof(B)}(A, B, N, n)
    end 

    function StiefelLieAlgHorMatrix(A::SkewSymMatrix, n::Int)
        N = A.n 
        @assert N > n 

        A_small = SkewSymMatrix(A[1:n,1:n])
        B = A[(n+1):N,1:n]
        new{eltype(A),typeof(A), typeof(B)}(A_small, B, N, n)
    end
end 

Base.parent(A::StiefelLieAlgHorMatrix) = (A, B)
Base.size(A::StiefelLieAlgHorMatrix) = (A.N, A.N)

function Base.getindex(A::StiefelLieAlgHorMatrix, i, j)
    if i ≤ A.n
        if j ≤ A.n 
            return A.A[i, j]
        end
        return -A.B[j - n, i]
    end
    if j ≤ A.n 
        return A.B[i - n, j]
    end
    return zero(eltype(A))
end