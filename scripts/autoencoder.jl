using MLDatasets 
using Random
using GeometricMachineLearning
using LinearAlgebra

using Lux
#Lux is needed for this flatten operation -> should be removed!
import Flux, Zygote

train_x, train_y = MNIST.traindata()
#for visualization
#using ImageInTerminal, ImageShow
#convert2image(MNIST, train_x[:,:,1])

train_x = Flux.flatten(train_x) # .|> gpu
train_y = Flux.onehotbatch(train_y, 0:9)

#encoder layer
Ψᵉ = Chain(
    Dense(28*28, 16, tanh),
    Dense(16, 16, tanh),
    Dense(16,10, Lux.σ)
    )

#decoder layer
Ψᵈ = Chain(
    Dense(10, 16, tanh),
    Dense(16, 16, tanh),
    Dense(16, 28*28, Lux.σ)
)

const model = Chain(Ψᵉ, Ψᵈ)

ps, st = Lux.setup(Random.default_rng(), model) # .|> gpu

#loss_sing
function loss_sing(ps, train_x, train_y, index)
    norm(Lux.apply(model, train_x[:, index], ps, st)[1] - train_x[:, index])
end
function loss(ps, train_x, train_y, batch_size=10)
    num = size(train_x,2)
    indices = Int.(ceil.(rand(batch_size)*num))
    mapreduce(index -> loss_sing(ps, train_x, train_y, index), +, indices)
end

function full_loss(ps, train_x, train_y)
    loss = 0 
    num = size(train_x,2)
    for i in 1:num
        pic_new = Lux.apply(model, train_x[:, i], ps, st)[1]
        loss += norm(pic_new - train_x[:, i])
    end
    loss 
end

o = AdamOptimizer()
cache = init_optimizer_cache(model, o)
println("initial loss: ", full_loss(ps, train_x, train_y))

training_steps = 3
loss_closure(ps) = loss(ps, train_x, train_y)
for i in 1:training_steps
    #@time dp = Zygote.gradient(loss_closure, ps)[1]
    @time l, pb = Zygote.pullback(loss_closure, ps)
    @time dp = pb(one(l))[1]
    optimization_step!(o, model, ps, cache, dp)
end
println("final loss: ", full_loss(ps, train_x, train_y))
