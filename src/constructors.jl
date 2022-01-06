#=
using Unitful: R, L, mol, K, kJ, °C, m, g, cm, hr, mg, s, μmol
=#

#= needs to be an array
struct DAMMparams  
  αₛₓ::Float64 # Pre-exponential factor
  Eaₛₓ::Float64 # Activation energy
  kMₛₓ::Float64 # Michaelis constant for substrate
  kMₒ₂::Float64 # Michaelis constant for O₂
  porosity::Float64 # Soil bulk density / soil particle density
  Sxₜₒₜ::Float64 # Total soil carbon
end
=#

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

#=
p = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125)
p = DAMMparams(p)
P = DAMMparams_u(p)
P[:αₛₓ]
=#
