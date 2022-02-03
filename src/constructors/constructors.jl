"""
    struct sDAMMmat
Fields required to plot surface of DAMM

# Fields
$(TYPEDFIELDS)
"""
struct sDAMMmat
  porosity::Float64
  params::NTuple{7, Float64}
  x::Array{Float64, 1}
  y::Array{Float64, 1}
  DAMM_Matrix::Array{Float64, 2}
end

"""
    struct sDAMMmatq
Fields required to plot surface of DAMM

# Fields
$(TYPEDFIELDS)
"""
struct sDAMMmatq
  porosity::Float64
  Tmed::Array{Float64, 1}
  θmed::Array{Float64, 1}
  Rmed::Array{Float64, 1}
  params::NTuple{7, Float64}
  x::Array{Float64, 1}
  y::Array{Float64, 1}
  DAMM_Matrix::Array{Float64, 2}
end

#= IF LsqFit.jl allows params to be a struct, then use:
struct DAMMparams  
  αₛₓ::Float64 # Pre-exponential factor
  Eaₛₓ::Float64 # Activation energy
  kMₛₓ::Float64 # Michaelis constant for substrate
  kMₒ₂::Float64 # Michaelis constant for O₂
  porosity::Float64 # Soil bulk density / soil particle density
  Sxₜₒₜ::Float64 # Total soil carbon
end


#IF LsqFit.jl allows params to be a Dict, then use:
function DAMMparams(p::NTuple{6, Float64})  
  p = Dict([:αₛₓ, :Eaₛₓ, :kMₛₓ, :kMₒ₂, :porosity, :Sxₜₒₜ] 
	   .=> [p[1], p[2], p[3], p[4], p[5], p[6]])
end

function DAMMparams_u(p::Dict{Symbol, Float64}) # give unit to params
  αₛₓ = p[:αₛₓ]mg*cm^-3*hr^-1 
  Eaₛₓ = p[:Eaₛₓ]kJ*mol^-1 
  kMₛₓ = p[:kMₛₓ]g*cm^-3 
  kMₒ₂ = p[:kMₒ₂]L*L^-1 
  porosity = p[:porosity] 
  Sxₜₒₜ = p[:Sxₜₒₜ]g*cm^-3 
  P = Dict([:αₛₓ, :Eaₛₓ, :kMₛₓ, :kMₒ₂, :porosity, :Sxₜₒₜ] 
	   .=> [αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, porosity, Sxₜₒₜ])
  return P
end
=#
