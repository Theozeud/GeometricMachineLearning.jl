
abstract type SymplecticEuler <: HnnTrainingIntegrator end

struct SymplecticEulerA <: SymplecticEuler end
struct SymplecticEulerB <: SymplecticEuler end

SEuler(;sqdist = sqeuclidean) =  SEulerA(sqdist = sqdist)
SEulerA(;sqdist = sqeuclidean) = TrainingIntegrator(SymplecticEulerA(), sqdist = sqdist)
SEulerB(;sqdist = sqeuclidean) = TrainingIntegrator(SymplecticEulerB(), sqdist =sqdist)

            
function loss_single(::SymplecticEulerA, nn::LuxNeuralNetwork{<:HamiltonianNeuralNetwork}, qₙ, qₙ₊₁, pₙ, pₙ₊₁, Δt, params = nn.params)
    dH = vectorfield(nn, [qₙ₊₁...,pₙ...], params)
    sqeuclidean(dH[1],(qₙ₊₁-qₙ)/Δt) + sqeuclidean(dH[2],(pₙ₊₁-pₙ)/Δt)
end

function loss_single(::SymplecticEulerB, nn::LuxNeuralNetwork{<:HamiltonianNeuralNetwork}, qₙ, qₙ₊₁, pₙ, pₙ₊₁, Δt, params = nn.params)
    dH = vectorfield(nn, [qₙ...,pₙ₊₁...], params)
    sqeuclidean(dH[1],(qₙ₊₁-qₙ)/Δt) + sqeuclidean(dH[2],(pₙ₊₁-pₙ)/Δt)
end


loss(ti::SymplecticEuler, nn::LuxNeuralNetwork{<:HamiltonianNeuralNetwork}, data::TrainingData{DataSymbol{<:PhaseSpaceSymbol}}, index_batch = get_batch(data), params = nn.params) = 
mapreduce((args...)->loss_single(Zygote.ignore(ti), nn, get_data(data,:q, args...), get_data(data,:q, next(args...)...), get_data(data,:p, args...), get_data(data,:p,next(args...)), get_Δt(data), params),+, index_batch)

data_goal(::SymplecticEuler) = (test_data_trajectory,)

required_key(::SymplecticEuler) = (:q,:p)

min_length_batch(::SymplecticEuler) = 2

