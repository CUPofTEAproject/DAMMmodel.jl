#= The Dual Arrhenius and Michealis-Menten (DAMM) model, Davidson et al. 2012
using Unitful: R, L, mol, K, kJ, °C, m, g, cm, hr, mg, s, μmol
using UnitfulMoles: molC
using Unitful, UnitfulMoles
@compound CO₂
include("constants.jl")
=#

"""
    DAMM(x::VecOrMat{<: Real}, p::NTuple{6, Float64})

Calculate respiration as a function of soil temperature and moisture.

# Examples
```julia-repl
julia> Tₛ = [18.0, 22.0] # soil temperature [°C]
julia> θ = [0.35, 0.22] # soil moisture [m³ m⁻³]
julia> x = hcat(Tₛ, θ)
julia> p = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125) # αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, Sxₜₒₜ
julia> DAMM(x, p)
  1.6 # μmolCO₂ m⁻² s⁻¹ 
  2.8 # μmolCO₂ m⁻² s⁻¹
```
"""
function DAMM(x::VecOrMat{<: Real}, p::NTuple{6, Float64})
# Independent variables
  Tₛ = x[:, 1]°C # Soil temperature
  Tₛ = Tₛ .|> K # Tₛ in Kelvin
  θ = x[:, 2]m^3*m^-3 # Soil moisture, m³ m⁻³
# Parameters 
  αₛₓ = p[1]mg*cm^-3*hr^-1 # Pre-exponential factor, mgC cm⁻³ h⁻¹
  Eaₛₓ = p[2]kJ*mol^-1 # Activation energy, kJ mol⁻¹
  kMₛₓ = p[3]g*cm^-3 # Michaelis constant, gC cm⁻³
  kMₒ₂ = p[4]L*L^-1 # Michaelis constant for O₂, L L⁻¹
  porosity = p[5] # 1 - soil buld density / soil particle density
  Sxₜₒₜ = p[6]g*cm^-3 # Total soil carbon, gC cm⁻³
# DAMM model
  Vmax = @. αₛₓ * exp(-Eaₛₓ/(R * Tₛ)) # Maximum potential rate of respiration
  Sₓ = @. pₛₓ * Sxₜₒₜ * Dₗᵢ * θ^3 # All soluble substrate, gC cm⁻³
  MMₛₓ = @. Sₓ / (kMₛₓ + Sₓ) # Availability of substrate factor, 0-1 
  O₂ = @. Dₒₐ * O₂ₐ * ((porosity - θ)^(4/3)) # Oxygen concentration
  MMₒ₂ = @. O₂ / (kMₒ₂ + O₂) # Oxygen limitation factor, 0-1
  Rₛₘ = @. Vmax * MMₛₓ * MMₒ₂ # Respiration, mg C cm⁻³ hr⁻¹
  Rₛₘₛ = @. Rₛₘ * Eₛ # Respiration, effective depth 10 cm, mg C cm⁻² hr⁻¹ 
  Rₛₛₘ = Rₛₘₛ .|> molC*m^-2*s^-1 
  Rₛ = Rₛₛₘ .|> μmolCO₂*m^-2*s^-1
  Rₛ = Float64.(ustrip(Rₛ)) # no units
  return Rₛ
end
