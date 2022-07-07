
struct FeedForwardLayer{DT,N,M,ST,WT,BT} <: NeuralNetworkLayer{DT,N,M}
    σ::ST
    W::WT
    b::BT

    function FeedForwardLayer(σ, W::AbstractMatrix{DT}, b::AbstractVector{DT}) where {DT}
        @assert length(axes(W,1)) == length(axes(b,1))
        new{DT, length(axes(W,2)), length(axes(W,1)), typeof(σ), typeof(W), typeof(b)}
    end
end

function apply!(output::AbstractVector, input::AbstractVector, layer::FeedForwardLayer)
    mul!(output, layer.W, input)
    output .+= layer.b
    output .= layer.σ.(output)
end
