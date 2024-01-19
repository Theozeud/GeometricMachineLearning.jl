description(::Val{:Batch}) = raw"""
`Batch` is a struct with an associated functor that acts on an instance of `DataLoader`. 

The constructor of `Batch` takes `batch_size` (an integer) as input argument. Optionally we can provide `seq_length` if we deal with time series data and want to draw batches of a certain *length* (i.e. the second dimension of the input array).
"""

"""
$(description(Val(:Batch)))
"""
struct Batch{seq_type <: Union{Nothing, Integer}}
    batch_size::Int
    seq_length::seq_type

    function Batch(batch_size, seq_length = nothing)
        new{typeof(seq_length)}(batch_size, seq_length)
    end
end

hasseqlength(::Batch{<:Integer}) = true
hasseqlength(::Batch{<:Nothing}) = false

description(::Val{:batch_functor_matrix}) = raw"""
For a snapshot matrix (or a `NamedTuple` of the form `(q=A, p=B)` where `A` and `B` are matrices), the functor for `Batch` is called on an instance of `DataLoader`. It then returns a tuple of batch indices: 
- for `autoencoder=true`: (\mathcal{I}_1, \ldots, \mathcal{I}_{\lceil\mathtt{n\_params/batch\_size}\rceil})``, where the index runs from 1 to the number of batches, which is the number of columns in the snapshot matrix divided by the batch size (rounded up).
- for `autoencoder=false`: (\mathcal{I}_1, \ldots, \mathcal{I}_{\lceil\mathtt{dl.input\_time\_steps/batch\_size}\rceil})``, where the index runs from 1 to the number of batches, which is the number of columns in the snapshot matrix (minus one) divided by the batch size (rounded up).
"""

"""
$(description(Val(:batch_functor_matrix)))
"""
function (batch::Batch{<:Nothing})(dl::DataLoader{T, AT}) where {T, BT<:AbstractMatrix{T}, AT<:Union{BT, NamedTuple{(:q, :p), Tuple{BT, BT}}}}
    number_columns = isnothing(dl.input_time_steps) ? dl.n_params : dl.input_time_steps
    indices = shuffle(1:number_columns)
    n_batches = Int(ceil(number_columns / batch.batch_size))
    batches = ()
    for batch_number in 1:(n_batches - 1)
        batches = (batches..., indices[(batch_number - 1) * batch.batch_size + 1 : batch_number * batch.batch_size])
    end
    (batches..., indices[(n_batches - 1) * batch.batch_size + 1:number_columns])
end

description(::Val{:batch_functor_tensor}) = raw"""
The functor for batch is called with an instance on `DataLoader`. It then returns a tuple of batch indices: ``(\mathcal{I}_1, \ldots, \mathcal{I}_{\lceil\mathtt{dl.n\_params/batch\_size}\rceil})``, where the index runs from 1 to the number of batches, which is the number of parameters divided by the batch size (rounded up).
"""

"""
$(description(Val(:batch_functor_tensor)))
"""
function (batch::Batch{<:Nothing})(dl::DataLoader{T, AT}) where {T, AT<:AbstractArray{T, 3}}
    indices = shuffle(1:dl.n_params)
    n_batches = Int(ceil(dl.n_params / batch.batch_size))
    batches = ()
    for batch_number in 1:(n_batches-1)
        batches = (batches..., indices[(batch_number - 1) * batch.batch_size + 1 : batch_number * batch.batch_size])
    end

    # this is needed because the last batch may not have the full size
    batches = (batches..., indices[( (n_batches-1) * batch.batch_size + 1 ) : end])
    batches
end

#=
function (batch::Batch{<:Integer})(dl::DataLoader{T, AT, Nothing}) where {T, AT<:AbstractArray{T, 3}}
    n_starting_points = n_params
    ...
end 
=#

@doc raw"""
Optimize for an entire epoch. For this you have to supply: 
- an instance of the optimizer.
- the neural network model 
- the parameters of the model 
- the data (in form of `DataLoader`)
- in instance of `Batch` that contains `batch_size` (and optionally `seq_length`)

With the optional argument:
- the loss, which takes the `model`, the parameters `ps` and an instance of `DataLoader` as input.

The output of `optimize_for_one_epoch!` is the average loss over all batches of the epoch:
```math
output = \frac{1}{\mathtt{steps\_per\_epoch}}\sum_{t=1}^\mathtt{steps\_per\_epoch}loss(\theta^{(t-1)}).
```
This is done because any **reverse differentiation** routine always has two outputs: a pullback and the value of the function it is differentiating. In the case of zygote: `loss_value, pullback = Zygote.pullback(ps -> loss(ps), ps)` (if the loss only depends on the parameters).
"""
function optimize_for_one_epoch!(opt::Optimizer, model, ps::Union{Tuple, NamedTuple}, dl::DataLoader{T, AT, BT}, batch::Batch, loss) where {T, T1, AT<:AbstractArray{T, 3}, BT<:AbstractArray{T1, 3}}
    count = 0
    total_error = T(0)
    batches = batch(dl)
    @views for batch_indices in batches 
        count += 1
        # these `copy`s should not be necessary! coming from a Zygote problem!
        input_batch = copy(dl.input[:, :, batch_indices])
        output_batch = copy(dl.output[:, :, batch_indices])
        loss_value, pullback = Zygote.pullback(ps -> loss(model, ps, input_batch, output_batch), ps)
        total_error += loss_value
        dp = pullback(one(loss_value))[1]
        optimization_step!(opt, model, ps, dp)
    end
    total_error/count
end

function optimize_for_one_epoch!(opt::Optimizer, model, ps::Union{Tuple, NamedTuple}, dl::DataLoader{T, AT, BT}, batch::Batch) where {T, T1, AT<:AbstractArray{T, 3}, BT<:AbstractArray{T1, 3}}
    optimize_for_one_epoch!(opt, model, ps, dl, batch, loss)
end

function optimize_for_one_epoch!(opt::Optimizer, nn::NeuralNetwork, dl::DataLoader, batch::Batch)
    optimize_for_one_epoch!(opt, nn.model, nn.params, dl, batch)
end

"""
This routine is called if a `DataLoader` storing *symplectic data* (i.e. a `NamedTuple`) is supplied.
"""
function optimize_for_one_epoch!(opt::Optimizer, model, ps::Union{Tuple, NamedTuple}, dl::DataLoader{T, AT}, batch::Batch, loss) where {T, AT<:NamedTuple}
    count = 0 
    total_error = T(0)
    batches = batch(dl)
    @views for batch_indices in batches 
        count += 1
        input_batch = (q=copy(dl.input.q[:,batch_indices]), p=copy(dl.input.p[:,batch_indices]))
        # add +1 here !!!!
        output_batch = (q=copy(dl.input.q[:,batch_indices.+1]), p=copy(dl.input.p[:,batch_indices.+1]))
        loss_value, pullback = Zygote.pullback(ps -> loss(model, ps, input_batch, output_batch), ps)
        total_error += loss_value 
        dp = pullback(one(loss_value))[1]
        optimization_step!(opt, model, ps, dp)
    end
    total_error/count
end

@doc raw"""
A functor for `Optimizer`. It is called with:
    - `nn::NeuralNetwork`
    - `dl::DataLoader`
    - `batch::Batch`
    - `n_epochs::Int`
    - `loss`

The last argument is a function through which `Zygote` differentiates. This argument is optional; if it is not supplied `GeometricMachineLearning` defaults to an appropriate loss for the `DataLoader`.
"""
function (o::Optimizer)(nn::NeuralNetwork, dl::DataLoader, batch::Batch, n_epochs::Int, loss)
    progress_object = ProgressMeter.Progress(n_epochs; enabled=true)
    loss_array = zeros(n_epochs)
    for i in 1:n_epochs
        loss_array[i] = optimize_for_one_epoch!(o, nn.model, nn.params, dl, batch, loss)
        ProgressMeter.next!(progress_object; showvalues = [(:TrainingLoss, loss_array[i])]) 
    end
    loss_array
end

function (o::Optimizer)(nn::NeuralNetwork, dl::DataLoader, batch::Batch, n_epochs::Int=1)
    o(nn, dl, batch, n_epochs, loss)
end