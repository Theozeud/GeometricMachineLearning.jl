"""
This splits the input x into q and p part (works with kernels also on GPU). For now this is only used in the Sympnet.
"""

@kernel function assign_first_half!(q::AbstractVector, x::AbstractVector)
    i = @index(Global)
    q[i] = x[i]
end

@kernel function assign_second_half!(p::AbstractVector, x::AbstractVector, N::Integer)
    i = @index(Global)
    p[i] = x[i+N]
end

@kernel function assign_first_half!(q::AbstractMatrix, x::AbstractMatrix)
    i,j = @index(Global, NTuple)
    q[i,j] = x[i,j]
end

@kernel function assign_second_half!(p::AbstractMatrix, x::AbstractMatrix, N::Integer)
    i,j = @index(Global, NTuple)
    p[i,j] = x[i+N,j]
end

function assign_q_and_p(x::Vector, N)
    backend = KernelAbstractions.get_backend(x)
    q = KernelAbstractions.allocate(backend, eltype(x), N)
    p = KernelAbstractions.allocate(backend, eltype(x), N)
    q_kernel! = assign_first_half!(backend)
    p_kernel! = assign_second_half!(backend)
    q_kernel!(q, x, ndrange=size(q))
    p_kernel!(p, x, N, ndrange=size(p))
    (q, p)
end

function assign_q_and_p(x::Matrix, N)
    backend = KernelAbstractions.get_backend(x)
    q = KernelAbstractions.allocate(backend, eltype(x), N, size(x,2))
    p = KernelAbstractions.allocate(backend, eltype(x), N, size(x,2))
    q_kernel! = assign_first_half!(backend)
    p_kernel! = assign_second_half!(backend)
    q_kernel!(q, x, ndrange=size(q))
    p_kernel!(p, x, N, ndrange=size(p))
    (q, p)
end