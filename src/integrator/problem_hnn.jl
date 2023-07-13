# This file contains the functions to create the corresponding problem to hnn which is HODEProblem

function HNNProblem(nn::LuxNeuralNetwork{<:HamiltonianNeuralNetwork}, tspan, tstep, ics::NamedTuple; kwargs...)

    Hₛₚₗᵢₜ(q, p) = nn([q..., p...])

    ∇Hₛₚₗᵢₜ(q, p) = Zygote.gradient(Hₛₚₗᵢₜ, q, p)

    function v(v, t, q, p, params)
        v .= ∇Hₛₚₗᵢₜ(q,p)[2]
    end

    function f(f, t, q, p, params)
        f .= - ∇Hₛₚₗᵢₜ(q,p)[1]
    end

    function hamiltonian(t, q, p, params) 
        Hₛₚₗᵢₜ(q, p)
    end
    HODEProblem(v, f, hamiltonian, tspan, tstep, ics; kwargs...)
end

function HNNProblem(nn::LuxNeuralNetwork{<:HamiltonianNeuralNetwork}, tspan, tstep, q₀::State, p₀::State; kwargs...)
    ics = (q = q₀, p = p₀)
    HNNProblem(nn, tspan, tstep, ics; kwargs...)
end




