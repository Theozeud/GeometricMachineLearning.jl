#= 
    TrainingParameters brings together all the parameters required for training, which are :
        - nruns: number of iterations for training,
        - method: the training integrator used in the loss function,
        - mopt: the method of optimization,
        - bs: the size of the subset of data used at each stage and chosen at random to calculate the loss.
=#

struct TrainingParameters{TM, TO, Tbatch}
    nruns::Int
    method::TM
    mopt::TO
    bs::Tbatch

    function TrainingParameters(nruns, method, mopt = default_optimizer(); batch_size = nothing)
        new{typeof(method), typeof(mopt), typeof(bs)}(nruns, method, mopt, batch_size)
    end
end

function TrainingParameters(tp::TrainingParameters; nruns = nruns(tp), method = method(tp), opt = opt(tp), batch_size = batchsize(tp))
    TrainingParameters(nruns, method, opt; batch_size = batch_size)
end

@inline nruns(tp::TrainingParameters) = tp.nruns
@inline method(tp::TrainingParameters) = tp.method
@inline opt(tp::TrainingParameters) = tp.opt
@inline batchsize(tp::TrainingParameters) = tp.bs

