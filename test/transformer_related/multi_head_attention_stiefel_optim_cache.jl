using GeometricMachineLearning, Test

import Lux, Random, LinearAlgebra

dim = 64
n_heads = 8
Dₕ = dim÷8
tol = eps(Float32)

d = MultiHeadAttention(dim, n_heads, Stiefel=true)
ps, st = Lux.setup(Random.default_rng(), d)

o₁ = Optimizer(AdamOptimizer(), ps)
o₂ = Optimizer(MomentumOptimizer(), ps)
o₃ = Optimizer(GradientOptimizer(), ps)

function check_adam_cache(C::AbstractCache) 
    @test typeof(C) <: AdamCache 
    @test propertynames(C) == (:B₁, :B₂)
    @test typeof(C.B₁) <: StiefelLieAlgHorMatrix
    @test typeof(C.B₂) <: StiefelLieAlgHorMatrix
    @test LinearAlgebra.norm(C.B₁) < tol
    @test LinearAlgebra.norm(C.B₂) < tol
end 
check_adam_cache(B::NamedTuple) = apply_toNT(B, check_adam_cache)

function check_momentum_cache(C::AbstractCache)
    @test typeof(C) <: MomentumCache 
    @test propertynames(C) == (:B,)
    @test typeof(C.B) <: StiefelLieAlgHorMatrix
    @test LinearAlgebra.norm(C.B) < tol
end
check_momentum_cache(B::NamedTuple) = apply_toNT(B, check_momentum_cache)

function check_gradient_cache(C::AbstractCache)
    @test typeof(C) <: GradientCache 
    @test propertynames(C) == ()
end
check_gradient_cache(B::NamedTuple) = apply_toNT(B, check_gradient_cache)

check_adam_cache(o₁.cache)
check_momentum_cache(o₂.cache)
check_gradient_cache(o₃.cache)
