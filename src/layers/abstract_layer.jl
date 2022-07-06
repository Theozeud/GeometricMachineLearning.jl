
@doc raw"""
A `NeuralNetworkLayer` is a map from $\mathbb{R}^{N} \rightarrow \mathbb{R}^{M}$.
"""
abstract type NeuralNetworkLayer{DT,N,M} end

function apply!(::AbstractVector, ::AbstractVector, layer::NeuralNetworkLayer)
    error("apply! not implemented for layer type ", typeof(layer))
end
