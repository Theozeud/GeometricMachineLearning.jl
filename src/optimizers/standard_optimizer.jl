"""
Define the Standard optimizer, i.e. W ← W - η*∇f(W)
Or the riemannian manifold equivalent, if applicable.
"""
mutable struct StandardOptimizer{T} <: AbstractOptimizer
    η::T
    t::Integer
    StandardOptimizer(η = 1e-2) = new{typeof(η)}(η,0)
end

function update!(o::StandardOptimizer, ::StandardCache, B::AbstractMatrix)
    B = -o.η*B
end


#update for single layer
#function update!(o::StandardOptimizer, ::StandardLayerCache, B::NamedTuple)
#    #o.t += 1
#    for key in keys(B)
#        B[key] .= -o.η*B[key]
#    end
#    B
#end
