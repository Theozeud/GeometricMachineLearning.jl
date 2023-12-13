@doc raw"""
`StiefelLieAlgHorMatrix` is the *horizontal component of the Lie algebra of skew-symmetric matrices* (with respect to the canonical metric).
The projection here is: \(\pi:S \to SE \) where 
```math
E = \begin{pmatrix} \mathbb{I}_{n} \\ \mathbb{O}_{(N-n)\times{}n}  \end{pmatrix}.
```
The matrix \(E\) is implemented under `StiefelProjection` in `GeometricMachineLearning`.

An element of StiefelLieAlgMatrix takes the form: 
```math
\begin{pmatrix}
A & B^T \\ B & \mathbb{O}
\end{pmatrix},
```
where \(A\) is skew-symmetric (this is `SkewSymMatrix` in `GeometricMachineLearning`).

If the constructor is called with a big \(N\times{}N\) matrix, then the projection is performed the following way: 
```math
\begin{pmatrix}
A & B_1  \\
B_2 & D
\end{pmatrix} \mapsto 
\begin{pmatrix}
\mathrm{skew}(A) & -B_2^T \\ 
B_2 & \mathbb{O}
\end{pmatrix}.
```
The operation $\mathrm{skew}:\mathbb{R}^{n\times{}n}\to\mathcal{S}_\mahtrm{skew}(n)$ is the skew-symmetrization operation. This is equivalent to calling the constructor of `SkewSymMatrix` with an \(n\times{}n\) matrix.
"""
mutable struct StiefelLieAlgHorMatrix{T, AT <: SkewSymMatrix{T}, ST <: AbstractMatrix{T}} <: AbstractLieAlgHorMatrix{T}
    A::AT
    B::ST
    N::Int
    n::Int 

    #maybe modify this - you don't need N & n as inputs!
    function StiefelLieAlgHorMatrix(A::SkewSymMatrix{T}, B::AbstractMatrix{T}, N::Integer, n::Integer) where {T}
        @assert n == A.n == size(B,2) 
        @assert N == size(B,1) + n

        new{T, typeof(A), typeof(B)}(A, B, N, n)
    end 
    
    function StiefelLieAlgHorMatrix(A::AbstractMatrix, n::Integer)
        N = size(A, 1)
        @assert N ≥ n 

        A_small = SkewSymMatrix(A[1:n,1:n])
        B = A[(n+1):N,1:n]
        new{eltype(A),typeof(A_small), typeof(B)}(A_small, B, N, n)
    end
end 

Base.parent(A::StiefelLieAlgHorMatrix) = (A, B)
Base.size(A::StiefelLieAlgHorMatrix) = (A.N, A.N)

function Base.getindex(A::StiefelLieAlgHorMatrix{T}, i, j) where {T}
    if i ≤ A.n
        if j ≤ A.n 
            return A.A[i, j]
        end
        return -A.B[j - A.n, i]
    end
    if j ≤ A.n 
        return A.B[i - A.n, j]
    end
    return T(0.)
end

function Base.:+(A::StiefelLieAlgHorMatrix, B::StiefelLieAlgHorMatrix)
    @assert A.N == B.N 
    @assert A.n == B.n 
    StiefelLieAlgHorMatrix( A.A + B.A, 
                            A.B + B.B, 
                            A.N,
                            A.n)
end

function Base.:-(A::StiefelLieAlgHorMatrix, B::StiefelLieAlgHorMatrix)
    @assert A.N == B.N 
    @assert A.n == B.n 
    StiefelLieAlgHorMatrix( A.A - B.A, 
                            A.B - B.B, 
                            A.N,
                            A.n)
end

function add!(C::StiefelLieAlgHorMatrix, A::StiefelLieAlgHorMatrix, B::StiefelLieAlgHorMatrix)
    @assert A.N == B.N == C.N
    @assert A.n == B.n == C.n 
    add!(C.A, A.A, B.A) 
    add!(C.B, A.B, B.B)  
end


function Base.:-(A::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(-A.A, -A.B, A.N, A.n)
end

function Base.:*(A::StiefelLieAlgHorMatrix, α::Real)
    StiefelLieAlgHorMatrix( α*A.A, α*A.B, A.N, A.n)
end

Base.:*(α::Real, A::StiefelLieAlgHorMatrix) = A*α

function Base.zeros(::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T
    StiefelLieAlgHorMatrix(
        zeros(SkewSymMatrix{T}, n),
        zeros(T, N-n, n),
        N, 
        n
    )
end
    
function Base.zeros(::Type{StiefelLieAlgHorMatrix}, N::Integer, n::Integer)
    StiefelLieAlgHorMatrix(
        zeros(SkewSymMatrix, n),
        zeros(N-n, n),
        N, 
        n
    )
end

function Base.zeros(backend::KernelAbstractions.Backend, ::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T 
	StiefelLieAlgHorMatrix(
			       zeros(backend, SkewSymMatrix{T}, n), 
			       KernelAbstractions.zeros(backend, T, N-n, n),
							N,
	n)
end


Base.similar(A::StiefelLieAlgHorMatrix, dims::Union{Integer, AbstractUnitRange}...) = zeros(StiefelLieAlgHorMatrix{eltype(A)}, dims...)
Base.similar(A::StiefelLieAlgHorMatrix) = zeros(StiefelLieAlgHorMatrix{eltype(A)}, A.N, A.n)

function Base.rand(rng::Random.AbstractRNG, backend::KernelAbstractions.Backend, ::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T 
    B = KernelAbstractions.allocate(backend, T, N-n, n)
    rand!(rng, B)
    StiefelLieAlgHorMatrix(rand(rng, backend, SkewSymMatrix{T}, n), B, N, n)
end

function Base.rand(backend::KernelAbstractions.Backend, type::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T 
    rand(Random.default_rng(), backend, type, N, n)
end

function Base.rand(rng::Random.AbstractRNG, ::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T
    StiefelLieAlgHorMatrix(rand(rng, SkewSymMatrix{T}, n), rand(rng, T, N-n, n), N, n)
end

function Base.rand(rng::Random.AbstractRNG, ::Type{StiefelLieAlgHorMatrix}, N::Integer, n::Integer)
    StiefelLieAlgHorMatrix(rand(rng, SkewSymMatrix, n), rand(rng, N-n, n), N, n)
end

function Base.rand(::Type{StiefelLieAlgHorMatrix{T}}, N::Integer, n::Integer) where T
    rand(Random.default_rng(), StiefelLieAlgHorMatrix{T}, N, n)
end

function Base.rand(::Type{StiefelLieAlgHorMatrix}, N::Integer, n::Integer)
    rand(Random.default_rng(), StiefelLieAlgHorMatrix, N, n)
end

function scalar_add(A::StiefelLieAlgHorMatrix, δ::Real)
    StiefelLieAlgHorMatrix(scalar_add(A.A, δ), A.B .+ δ, A.N, A.n)
end

#define these functions more generally! (maybe make a fallback script!!)
function ⊙²(A::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(⊙²(A.A), A.B.^2, A.N, A.n)
end
function racᵉˡᵉ(A::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(racᵉˡᵉ(A.A), sqrt.(A.B), A.N, A.n)
end
function /ᵉˡᵉ(A::StiefelLieAlgHorMatrix, B::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(/ᵉˡᵉ(A.A, B.A), A.B./B.B, A.N, A.n)
end 

function LinearAlgebra.mul!(C::StiefelLieAlgHorMatrix, A::StiefelLieAlgHorMatrix, α::Real)
    mul!(C.A, A.A, α)
    mul!(C.B, A.B, α)
end
LinearAlgebra.mul!(C::StiefelLieAlgHorMatrix, α::Real, A::StiefelLieAlgHorMatrix) = mul!(C, A, α)
LinearAlgebra.rmul!(C::StiefelLieAlgHorMatrix, α::Real) = mul!(C, C, α)

function Base.vec(A::StiefelLieAlgHorMatrix)
    vcat(vec(A.A), vec(A.B))
end

function StiefelLieAlgHorMatrix(V::AbstractVector, N::Int, n::Int)
    # length of skew-symmetric matrix
    skew_sym_size = n*(n-1)÷2
    # size of matrix component 
    matrix_size = (N-n)*n
    @assert length(V) == skew_sym_size + matrix_size
    StiefelLieAlgHorMatrix(
        SkewSymMatrix(@view(V[1:skew_sym_size]), n),
        reshape(@view(V[(skew_sym_size+1):(skew_sym_size+matrix_size)]), (N-n), n),
        N, 
        n
    )
end

function Base.zero(B::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(
        zero(B.A),
        zero(B.B),
        B.N,
        B.n
    )
end

function KernelAbstractions.get_backend(B::StiefelLieAlgHorMatrix)
    KernelAbstractions.get_backend(B.B)
end

# assign funciton; also implement this for other arrays! 
function assign!(B::StiefelLieAlgHorMatrix{T}, C::StiefelLieAlgHorMatrix{T}) where T 
    assign!(B.A, C.A)
    B.B .= C.B 
end

function Base.copy(B::StiefelLieAlgHorMatrix)
    StiefelLieAlgHorMatrix(
        copy(B.A),
        copy(B.B),
        B.N,
        B.n
    )
end

# fallback -> put this somewhere else!
function assign!(A::AbstractArray, B::AbstractArray)
    A .= B 
end