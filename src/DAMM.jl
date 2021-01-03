# The Dual Arrhenius and Michealis-Menten (DAMM) model, Davidson et al. 2012
function DAMM(x, p)
     # Constants
	R = 8.314472e-3 # Universal gas constant, kJ K⁻¹ mol⁻¹
	O₂ₐ = 0.209 # Volume of O₂ in the air, L L⁻¹
	Dₗᵢ = 3.17 # Diffusion coefficient of substrate in liquid phase, dimensionless
	Dₒₐ = 1.67 # Diffusion coefficient of oxygen in air, dimensionless
	pₛₓ = 0.024 # Fraction of soil carbon that is considered soluble
	conv = 2314.8148 # Convert from mgC m⁻² hr⁻¹ to μmol CO₂ m⁻² s⁻¹
	CtoK = 273.15 # Convert °C to Kelvin
     # Independent variables
	Tₛ = x[:, 1] # Soil temperature, °C
	θ = x[:, 2] # Soil moisture, m³ m⁻³
     # Parameters 
	Eaₛₓ = p[1] # Activation energy, kJ mol⁻¹
	αₛₓ = p[2] # Pre-exponential factor, mgC cm⁻³ h⁻¹
	kMₒ₂ = p[3] # Michaelis constant for O₂, L L⁻¹
	kMₛₓ = p[4] # Michaelis constant, gC cm⁻³
	porosity = p[5] # 1 - soil buld density / soil particle density
	Sxₜₒₜ = p[6] # Total soil carbon, gC cm⁻³
     # DAMM model
	Vmaxₛₓ = @. (αₛₓ * exp(-Eaₛₓ/(R * (CtoK + Tₛ))))
     	Sₓ = @. pₛₓ * Sxₜₒₜ * Dₗᵢ * θ^3
	MMₛₓ = @. Sₓ / (kMₛₓ + Sₓ)
	O₂ = @. Dₒₐ * O₂ₐ * ((porosity - θ)^(4/3))
	MMₒ₂ = @. O₂ / (kMₒ₂ + O₂)
	Resp = @. Vmaxₛₓ * MMₛₓ * MMₒ₂ * conv 
end
