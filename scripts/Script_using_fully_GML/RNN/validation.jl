using Plots, JLD2, GeometricIntegrators, AbstractNeuralNetworks, GeometricMachineLearning

# this file stores parameters relevant for the NN
file_nn = jldopen("nn_model", "r")
model = file_nn["model"]
params = file_nn["params"]
seq_length = file_nn["seq_length"]


# this file stores parameters relevant for dataset/vector field (theoretically only needed for validation!)
file_data = jldopen("data", "r")
time_step = file_data["time_step"]

# Computing the reference solution

function sigmoid(x::T) where {T<:Real}
	T(1)/(T(1) + exp(-x))
end

function q̇(v, t, q, p, params)
    v[1] = p[1]/params.m1
    v[2] = p[2]/params.m2
end

function ṗ(f, t, q, p, params)
	f[1] = -params.k1 * q[1] - params.k * (q[1] - q[2]) * sigmoid(q[1]) - params.k /2 * (q[1] - q[2])^2 * sigmoid(q[1])^2 * exp(-q[1])
	f[2] = -params.k2 * q[2] + params.k * (q[1] - q[2]) * sigmoid(q[1])
end

T = Float64

m1 = T(2.)
m2 = T(1.)
k1 = T(1.5)
k2 = T(0.3)
k = T(3.5)
params = (m1=m1, m2=m2, k1=k1, k2=k2, k=k)

initial_conditions_val = (q=[T(1.),T(0.)], p=[T(2.),T(0.)])

t_integration = 50

pode = PODEProblem(q̇, ṗ, (T(0.0), T(t_integration)), time_step, initial_conditions_val; parameters = params)
sol = integrate(pode, ImplicitMidpoint())

data_matrix = zeros(T, 4, Int(t_integration/time_step) + 1)
for i in 1:seq_length data_matrix[1:2, i] = sol.q[i-1] end 
for i in 1:seq_length data_matrix[3:4, i] = sol.p[i-1] end

# Computing the prediction

total_steps = Int(t_integration/time_step) - seq_length + 1

for i in 1:total_steps
    x = [data_matrix[:, i + j - 1] for j in 1:seq_length]
    data_matrix[:,i + seq_length] = model(x)
end

q1 = zeros(size(data_matrix,2))
t = zeros(size(data_matrix,2))
for i in 1:length(q1) 
    q1[i] = sol.q[i-1][1] 
    t[i] = sol.t[i-1]
end

# Plot of the validation

plt = plot(t, q1, label="Numeric Integration", size=(1000,600))
plot!(plt, t, data_matrix[1,:], label="Neural Network")
vline!(plt, [seq_length*time_step-1], color="red",label="Start of Prediction")

#png(plot1, "seq_length"*string(seq_length)*"_prediction_window"*string(prediction_window))
