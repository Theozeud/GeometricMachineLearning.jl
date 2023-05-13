#Default constants
const DEFAULT_SYMPNET_NRUNS = 1000
const DEFAULT_BATCH_SIZE = 10
const DEFAULT_SIZE_RESULTS = 10

# Structure
abstract type SympNet{AT} <: AbstractArchitecture end

struct LASympNet{AT} <: SympNet{AT} 
    dim::Int
    nhidden::Int
    act::AT

    function LASympNet(dim; nhidden=1, activation=tanh) #default opt ?
        new{typeof(activation)}(dim, width, nhidden, activation)
    end

end

struct GSympNet{AT} <: SympNet{AT} 
    dim::Int
    width::Int
    nhidden::Int
    act::AT

    function GSympNet(dim; width=dim, nhidden=1, activation=tanh) 
        new{typeof(activation)}(dim, width, nhidden, activation)
    end
end

# Chain function
function chain(nn::GSympNet, ::LuxBackend)
    inner_layers = Tuple(
        [Gradient(nn.dim, nn.width, nn.act, change_q = (i%2==1)) for i in 1:nn.nhidden]
    )
    Lux.Chain(
        inner_layers...
    )
end

function chain(nn::LASympNet, ::LuxBackend)
    couple_layers = []
    for _ in 1:nhidden
        push!(couple_layers,Linear(nn.dim))
        push!(couple_layers,Gradient(nn.dim, nn.dim, nn.act, full_grad = false))
    end
    
    Lux.Chain(
        couple_layers...,
        Linear(nn.dim)
    )
end

# Evaluation of the neural network

(nn::LuxNeuralNetwork{<:SympNet})(q, p, params = nn.params) = apply(nn, [q...,p...],params)

# Loss function

function loss(nn::LuxNeuralNetwork{<:SympNet}, q, p, params = nn.params, batch_size = 10)
    loss = 0
    #Index = sample(2:length(q), batch_size, replace = false)
    for i in 1:batch_size
        index = Int(ceil(rand()*(size(q,1)-1)))+1
        qp_new = nn(q[index-1,:], p[index-1,:], params)
        loss += norm(qp_new-[q[index,:]..., p[index,:]...])
    end
    loss
end

function full_loss(nn::LuxNeuralNetwork{<:SympNet}, q, p, params = nn.params)
    loss = 0
    #Index = 1:batch_size #sample(2:length(q), batch_size, replace = false)
    for index in 2:size(q,1)
        qp_new = nn(q[index-1,:], p[index-1,:], params)
        loss += norm(qp_new - [q[index,:]..., p[index,:]...])
    end
    loss
end

function grad_loss(nn::LuxNeuralNetwork{<:SympNet}, q, p, params = nn.params, batch_size = DEFAULT_BATCH_SIZE)
    Zygote.gradient(params -> loss(nn, q, p, params, batch_size), params)[1]
end


# Training

function train!(nn::LuxNeuralNetwork{<:SympNet}, m::AbstractMethodOptimiser, data_q, data_p; ntraining = DEFAULT_SYMPNET_NRUNS, batch_size = DEFAULT_BATCH_SIZE)
    
    #creation of optimiser
    opt = Optimizer(m,nn.model)

    # create array to store total loss
    total_loss = zeros(ntraining)

    # Learning runs
    @showprogress 1 "Training..." for j in 1:ntraining
        dp = grad_loss(nn, data_q, data_p, nn.params, batch_size)
        
        optimization_step!(opt, nn.model, nn.params, dp)
        total_loss[j] = full_loss(nn, data_q, data_p)
    end

    return total_loss
end


# Results

function Iterate_Sympnet(nn::LuxNeuralNetwork{<:SympNet}, q0, p0; n_points = DEFAULT_SIZE_RESULTS)

    n_dim = length(q0)
    
    # Array to store the predictions
    q_learned = zeros(n_points,n_dim)
    p_learned = zeros(n_points,n_dim)
    
    # Initialisation
    q_learned[1,:] = q0
    p_learned[1,:] = p0
    
    #Computation of phase space
    for i in 2:n_points
        qp_learned =  nn(q_learned[i-1,:], p_learned[i-1,:])
        q_learned[i,:] = qp_learned[1:n_dim]
        p_learned[i,:] = qp_learned[(1+n_dim):end]
    end

    return q_learned, p_learned
end