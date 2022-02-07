# The Dual Arrhenius and Michealis-Menten (DAMM) model, Davidson et al. 2012

"""
    DAMM(x::VecOrMat{<: Real}, p::NTuple{7, Float64})

Calculate respiration as a function of soil temperature (Tₛ) and moisture (θ).

# Examples
```julia-repl
julia> df = DAMMfdata(100) # generates a fake dataset
100×3 DataFrame
 Row │ Tₛ       θ        Rₛ        
     │ Float64  Float64  Float64   
─────┼─────────────────────────────
   1 │    15.5      0.3   1.72216
   2 │    22.3      0.6   1.8213
  ⋮  │    ⋮        ⋮         ⋮
  99 │     9.5      0.2   0.223677
 100 │     6.6      0.6   0.730627
julia> fp # parameters: αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, Sxₜₒₜ, Q10kM
(1.0e9, 64.0, 3.46e-8, 0.002, 0.7, 0.02, 1.0)
julia> DAMM(hcat(df.Tₛ, df.θ), fp) # μmolCO₂ m⁻² s⁻¹
100-element Vector{Float64}:
 6.023429035220588
 0.9298933641647085
 ⋮
 0.8444248717855868
 3.805243237387702
```
"""
function DAMM(x::VecOrMat{<: Real}, p::NTuple{7, Float64})
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
  Q10Km = p[7]
# DAMM model
  Tref = 293.15K
  Vmax = @. αₛₓ * exp(-Eaₛₓ/(R * Tₛ)) # Maximum potential rate of respiration
  Sₓ = @. pₛₓ * Sxₜₒₜ * Dₗᵢ * θ^3 # All soluble substrate, gC cm⁻³
  MMₛₓ = @. Sₓ / (kMₛₓ * Q10Km^(ustrip(Tₛ - Tref)/10.0) + Sₓ) # Availability of substrate factor, 0-1 
  porosityₐᵢᵣ = porosity .- θ # Air filled porosity
  porosityₐᵢᵣ[porosityₐᵢᵣ .< 0.0] .= NaN # Moisture cannot be greater than porosity
  O₂ = @. Dₒₐ * O₂ₐ * (porosityₐᵢᵣ^(4/3)) # Oxygen concentration
  MMₒ₂ = @. O₂ / (kMₒ₂ + O₂) # Oxygen limitation factor, 0-1
  Rₛₘ = @. Vmax * MMₛₓ * MMₒ₂ # Respiration, mg C cm⁻³ hr⁻¹
  Rₛₘₛ = @. Rₛₘ * Eₛ # Respiration, effective depth 10 cm, mg C cm⁻² hr⁻¹ 
  Rₛₛₘ = Rₛₘₛ .|> molC*m^-2*s^-1 
  Rₛ = Rₛₛₘ .|> μmolCO₂*m^-2*s^-1
  Rₛ = Float64.(ustrip(Rₛ)) # no units
  return Rₛ
end
