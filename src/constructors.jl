#=
using Unitful: R, L, mol, K, kJ, °C, m, g, cm, hr, mg, s, μmol
p = DAMMparams(1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125)
=#

struct DAMMparams  
  αₛₓ::Float64 # Pre-exponential factor
  Eaₛₓ::Float64 # Activation energy
  kMₛₓ::Float64 # Michaelis constant for substrate
  kMₒ₂::Float64 # Michaelis constant for O₂
  porosity::Float64 # Soil bulk density / soil particle density
  Sxₜₒₜ::Float64 # Total soil carbon
end

function DAMMparams_u(p::DAMMparams) # give unit to params
  αₛₓ = eval(p.αₛₓ)mg*cm^-3*hr^-1 
  Eaₛₓ = eval(p.Eaₛₓ)kJ*mol^-1 
  kMₛₓ = eval(p.kMₛₓ)g*cm^-3 
  kMₒ₂ = eval(p.kMₒ₂)L*L^-1 
  porosity = p.porosity 
  Sxₜₒₜ = eval(p.Sxₜₒₜ)g*cm^-3 
  P = Dict(["αₛₓ", "Eaₛₓ", "kMₛₓ", "kMₒ₂", "porosity", "Sxₜₒₜ"] .=> [αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, porosity, Sxₜₒₜ])
  return P
end

#=
P = DAMMparams_u(p)
P["αₛₓ"]
=#
