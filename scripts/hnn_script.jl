# using Profile
using GeometricMachineLearning

# this contains the functions for generating the training data
include("data_problem.jl")

H,n_dim = dict_problem_H[:pendulum]

# this contains the functions for generating the plots
# include("plots.jl")

# layer dimension/width
const ld = 5

# hidden layers
const ln = 3

# number of inputs/dimension of system
const ninput = 2

# number of training runs
const nruns = 1000

# Optimiser
#opt = GradientOptimizer(1e-2)
opt = MomentumOptimizer(1e-3,0.5)

# create HNN
hnn = HamiltonianNeuralNetwork(ninput; nhidden = ln, width = ld)

# create Lux network
nn = NeuralNetwork(hnn, LuxBackend())

# get data set
println("Begin generating data")
nameproblem = :pendulum
#data = get_multiple_trajectory_structure(nameproblem; n_trajectory = 10, n_points = 1000, tstep = 0.1, qmin = -1.2, pmin = -1.2, qmax = 1.2, pmax = 1.2)
#data_t = get_multiple_trajectory_structure_with_target(nameproblem; n_trajectory = 10, n_points = 100, tstep = 0.1, qmin = -1.2, pmin = -1.2, qmax = 1.2, pmax = 1.2)


Data,Target = get_HNN_data(nameproblem)
Get_nb_point(Data) = length(Data)
Get_q(Data,n) = Data[n][1]
Get_p(Data,n) = Data[n][2]
Get_q̇(Target,n) = Target[n][1]
Get_ṗ(Target,n) = Target[n][2]
pdata = data_sampled(Data, Get_nb_point, Get_q, Get_p)
data = dataTarget(pdata, Target, Get_q̇, Get_ṗ)

println("End generating data")


#training method
#hti = SEulerA()
hti = ExactIntegrator()

# perform training (returns array that contains the total loss for each training step)
total_loss = train!(nn, opt, data; ntraining = nruns, hti)


# plot results
include("plots.jl")
plot_hnn(H, nn, total_loss; filename="hnn_pendulum.png", xmin=-1.2, xmax=+1.2, ymin=-1.2, ymax=+1.2)



