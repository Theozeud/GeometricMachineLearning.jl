abstract type AbstractDataShape end

struct SampledData <: AbstractDataShape end

struct TrajectoryData <:  AbstractDataShape
    Δt::Union{Real,Nothing}
    nb_trajectory::Int
    length_trajectory::AbstractArray{Int}
    
    function TrajectoryData(Data, _get_data::Dict{Symbol, <:Base.Callable})
        
        @assert haskey(_get_data, :nb_trajectory)
        @assert haskey(_get_data, :length_trajectory)

        Δt = haskey(_get_data, :Δt) ? _get_data[:Δt](Data) : nothing

        nb_trajectory = _get_data[:nb_trajectory](Data)
        length_trajectory = [_get_data[:length_trajectory](Data, i) for i in 1:nb_trajectory]

        delete!(_get_data, :Δt)
        delete!(_get_data, :nb_trajectory)
        delete!(_get_data, :length_trajectory)
       
        new(Δt, nb_trajectory, length_trajectory)
    end
end


struct SampledData <:  AbstractDataShape
    get_nb_point::Base.Callable
  
    function SampledData(Data, _get_data::Dict{Symbol, <:Base.Callable})
            
        @assert haskey(_get_data, :nb_points)
        nb_point = _get_data[:nb_points](Data)

        delete!(_get_data, :nb_points)

        new(nb_point)
    end
end