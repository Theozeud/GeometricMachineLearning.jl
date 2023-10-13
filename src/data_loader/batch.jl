@doc raw"""
`Batch`` is a struct with an associated functor that acts on `DataLoader`. 

The functor returns indices that are then used in the optimization step (always for an entire epoch).
"""
struct Batch{seq_length}
    batch_size::Integer
    seq_length::Union{Nothing, Integer}
end

function Batch(batch_size::Integer)
    Batch{false}(batch_size, nothing)
end

function Batch(batch_size, seq_length)
    Batch{true}(batch_size, seq_length)
end

function (batch::Batch{false})(dl::DataLoader{T, AT}) where {T, AT<:AbstractArray{T}}
    indices = shuffle(1:dl.n_params)
    n_batches = Int(ceil(dl.n_params/batch.batch_size))
    batches = ()
    for batch_number in 1:(n_batches-1)
        batches = (batches..., indices[(batch_number-1)*batch.batch_size + 1:batch_number*batch.batch_size])
    end

    # this is needed because the last batch may not have the full size
    batches = (batches..., indices[( (n_batches-1) * batch.batch_size + 1 ):end])
    batches
end

#=
function (batch::Batch{true})(dl::DataLoader{T, AT, Nothing}) where {T, AT<:AbstractArray{T, 3}}
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
"""
function optimize_for_one_epoch!(opt::Optimizer, model, ps::Union{Tuple, NamedTuple}, dl::DataLoader{T, AT, BT}, batch::Batch, loss) where {T, T1, AT<:AbstractArray{T, 3}, BT<:AbstractArray{T1, 3}}
    count = 0
    total_error = T(0)
    batches = batch(dl)
    for batch_indices in batches 
        count += 1
        input_batch = @view dl.input[:, :, batch_indices]
        output_batch = @view dl.output[:, :, batch_indices]
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