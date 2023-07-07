#=
    TrainingSet gathers all information ready for a train. It contains
        - nn : an AbstractNeuralNetwork
        - tp : a TrainingParameters
        - data : an AbstractTrainingData
=#

struct TrainingSet{TN <: AbstractNeuralNetwork, TP<:TrainingParameters , TD<: AbstractTrainingData}
    nn::TN
    tp::TP
    data::TD

    function TrainingSet(nn::AbstractNeuralNetwork, tp::TrainingParameters, data::AbstractTrainingData)
        new{typeof(nn), typeof(tp), typeof(dada)}(nn,tp,data)
    end
end

TrainingSet(ts::TrainingSet; nn::AbstractNeuralNetwork = nn(ts), tp::TrainingParameters = parameters(ts), data::AbstractTrainingData = data(ts)) = TrainingSet(nn, tp, data)

@inline nn(ts::TrainingSet)= ts.nn
@inline parameters(ts::TrainingSet)= ts.tp
@inline data(ts::TrainingSet)= ts.data

