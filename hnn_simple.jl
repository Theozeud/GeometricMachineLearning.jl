using Distances
using Zygote
# using Profile
using ProgressMeter

#this contains the functions for generating the training data
include("plots_data/data.jl")

#this contains the functions for generating the plots
include("plots_data/plots.jl")

#layer dimension/width
const ld = 5

#number of inputs/dimension of system
const n_in = 2

#learning rate
const η = .001

#number of training runs
const runs = 1000

#evaluate neural network
function network(τ, model)
	#first layer
	layer1 = tanh.(model[1].W * τ .+ model[1].b)

	#second layer
	layer2 = tanh.(model[2].W * layer1 .+ model[2].b)

	#third layer (linear activation)
	return model[3].W * layer2
end

#compute vector field
function field(χ, model)
	[0 1; -1 0] * Zygote.gradient(χ -> sum(network(χ, model)), χ)[1]
end

function training!(model, data, target, η, nruns, loss, gloss)
	arr_loss = zeros(nruns)

	@showprogress 1 "Training..." for j in 1:nruns
		# get batch data
		batch_data, batch_target = get_batch(data, target)

		#compute loss function for a certain batch
		model_grad = gloss(batch_data, batch_target, model)
		for i in eachindex(model, model_grad)
			for (m, dm) in zip(model[i], model_grad[i])
				m .-= η .* dm
			end
		end

		#total loss i.e. loss computed over all data
		arr_loss[j] = loss(data, target, model)
	end

	return arr_loss
end

function train_hnn(n_in, ld, η, runs, DT=Float64)
	#initialise weights
	model = (
		(W = randn(DT, ld, n_in), b = randn(DT, ld)),
		(W = randn(DT, ld, ld),   b = randn(DT, ld)),
		(W = randn(DT, 1,  ld),                ),
	)

	#loss for single data point
	loss_sing(ξ, γ, model) = sqeuclidean(field(ξ, model), γ)

	#compute loss  
	loss(ξ, γ, model) = mapreduce(i -> loss_sing(ξ[i], γ[i], model), +, eachindex(ξ,γ))

	#compute gradient of loss
	loss_gradient(Y, T, model) = Zygote.gradient(M -> loss(Y, T, M), model)[1]

	#get data set
	data, target = get_data_set()

	#perform training (returns array that contains the total loss for each training step)
	total_loss = training!(model, data, target, η, runs, loss, loss_gradient)

	return (model, data, target, total_loss)
end

#train network
model, data, target, total_loss = train_hnn(n_in, ld, η, runs)

#time training (after warmup)
# train_hnn(n_in, ld, η, 1)
# @time model, data, target, total_loss = train_hnn(n_in, ld, η, runs)

#profile training
#run with julia --track-allocation=user hnn.jl
# Profile.clear()
# Profile.clear_malloc_data()
# @profile model, data, target, total_loss = train_hnn(n_in, ld, η, runs)

#learned Hamiltonian & vector field
H_est(τ) = sum(network(τ, model))
# dH_est(τ) = field(τ, model)

#plot results
plot_network(H, H_est, total_loss; filename="hnn_simple.png")
