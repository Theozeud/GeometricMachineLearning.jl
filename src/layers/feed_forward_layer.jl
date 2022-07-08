
struct FeedForwardLayer{DT, N, M, ST, WT <: AbstractMatrix{DT}, BT <: AbstractVector{DT}, GT} <: NeuralNetworkLayer{DT,N,M}
    σ::ST
    W::WT
    b::BT
    gradient::GT

    function FeedForwardLayer(σ, W::AbstractMatrix{DT}, b::AbstractVector{DT}, gradient) where {DT}
        @assert length(axes(W,1)) == length(axes(b,1))
        new{DT, length(axes(W,2)), length(axes(W,1)), typeof(σ), typeof(W), typeof(b), typeof(gradient)}(σ,W,b,gradient)
    end
end

(layer::FeedForwardLayer)(output, input) = apply!(output, input, layer)

function apply!(output::AbstractVector, input::AbstractVector, layer::FeedForwardLayer)
    mul!(output, layer.W, input)
    output .+= layer.b
    output .= layer.σ.(output)
end
