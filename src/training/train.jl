const DEFAULT_NRUNS = 1000

# The loss gradient function working for all types of arguments
loss_gradient(nn::LuxNeuralNetwork{<:AbstractArchitecture}, ti::AbstractTrainingIntegrator, data::AbstractTrainingData, index_batch, params = nn.params) = Zygote.gradient(p -> loss(ti, nn, data, index_batch, p), params)[1]

####################################################################################
## Training on (LuxNeuralNetwork, AbstractTrainingData, AbstractMethodOptimiser, TrainingIntegrator, nruns, batch_size )
####################################################################################

"""
    train!(...)

Perform a training of a neural networks on data using given method a training integrator

Different ways of use:

    train!(neuralnetwork, data, optimizer = GradientOptimizer(1e-2), training_method; nruns = 1000, batch_size = default(data, type), showprogress = false )

# Arguments
- `neuralnetwork::LuxNeuralNetwork` : the neural net work using LuxBackend
- `data` : the data (see [`TrainingData`](@ref))
- `optimizer = GradientOptimizer`: the optimization method (see [`Optimizer`](@ref))
- `training_method` : specify the loss function used 
- `nruns` : number of iteration through the process with default value 
- `batch_size` : size of batch of data used for each step


"""
function train!(nn::LuxNeuralNetwork{<:AbstractArchitecture}, data::AbstractTrainingData, m::AbstractMethodOptimiser, ti::TrainingIntegrator{<:AbstractTrainingIntegrator} = default_integrator(nn, data); ntraining = DEFAULT_NRUNS, batch_size_t = default_index_batch(data,type(ti)), showprogress::Bool = false)
    
    #verify that shape of data depending of the ExactIntegrator
    #assert(type(ti), data)

    # create array to store total loss
    total_loss = zeros(ntraining)

    #creation of optimiser
    opt = Optimizer(m, nn.model)

    # transform parameters (if needed) to match with Zygote
    params_tuple, keys =  pretransform(type(ti), nn.params)

    # Learning runs
    p = Progress(ntraining; enabled = showprogress)
    for j in 1:ntraining
        index_batch = get_batch(data, batch_size_t)

        params_grad = loss_gradient(nn, type(ti), data, index_batch, params_tuple) 

        dp = posttransform(type(ti), params_grad, keys)

        optimization_step!(opt, nn.model, nn.params, dp)

        total_loss[j] = loss(type(ti), nn, data)

        next!(p)
    end

    return total_loss
end

####################################################################################
## Training on (LuxNeuralNetwork, AbstractTrainingData, TrainingParameters)
####################################################################################

"""
```julia
train!(neuralnetwork, data, optimizer, training_method; nruns = 1000, batch_size, showprogress = false )
```

# Arguments
- `neuralnetwork::LuxNeuralNetwork` : the neural net work using LuxBackend
- `data::AbstractTrainingData` : the data
- ``

"""
function train!(nn::LuxNeuralNetwork{<:AbstractArchitecture}, data::AbstractTrainingData, tp::TrainingParameters; showprogress::Bool = false)

    total_loss = train!(nn, data, opt(tp), method(tp); ntraining = nruns(tp), batch_size_t = batch_size(tp), showprogress = showprogress)

    sh = SingleHistory(tp, shape(data), size(data), total_loss)
    
    NeuralNetSolution(nn, total_loss, sh, problem(data), tstep(data))

end

####################################################################################
## Training on a SingleTrainingSet structure
####################################################################################

function train!(sts::SingleTrainingSet; kwarsg...)

    train!(nn(sts), data(sts), parameters(sts); kwarsg...)

end

####################################################################################
## Training on a NeuralNetSolution with AbstractTrainingData and TrainingParameters
####################################################################################

function train!(nns::NeuralNetSolution, data::AbstractTrainingData, tp::TrainingParameters; kwarsg...)

    @assert tstep(data) == tstep(nns) || tstep(nns) == nothing || tstep(data) == nothing
    @assert problem(data) == problem(nns) || problem(nns) == nothing || problem(data) == nothing
    
    total_loss = train!(nn(nns), data, opt(tp), method(tp); ntraining = nruns(tp), batch_size_t = batch_size(tp), showprogress = showprogress)

    sh = SingleHistory(tp, shape(data), size(data), total_loss)

    new_history = _update(nns(history), sh)
    
    NeuralNetSolution(nn(nns), total_loss, new_history, problem(nns), tstep(nns))

end

function train!(nns::NeuralNetSolution, sts::SingleTrainingSet; kwarsg...)

    @assert nn(sts) == nn(nns)
    
    train!(nns::NeuralNetSolution, data(sts), parameters(sts); kwarsg...)

end



