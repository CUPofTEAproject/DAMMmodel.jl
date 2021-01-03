# Dual Arrhenius Michealis Menten (DAMM) model, Davidson et al. 2012
include("DAMM_param.jl")
function DAMM(x, p; fp = defaultfp)
	porosity = 1-fp.BD/fp.PD # total porosity
     # Independent variables
	Tₛ = x[:, 1]
	θ = x[:, 2]
     # Parameters to fit
	Eaₛₓ = p[1]
	αₛₓ = p[2]
	kMₒ₂ = p[3]
	kMₛₓ = p[4]
     # DAMM model
	Sₓ = @. fp.Sxₜₒₜ * fp.Dₗᵢ * θ^3
	O2 = @. fp.Dₒₐ * fp.O2ₐ * ((porosity - θ)^(4/3))
	MMₛₓ = @. Sₓ / (kMₛₓ + Sₓ)
	MMₒ₂ = @. O2 / (kMₒ₂ + O2)
	Vmaxₛₓ = @. (αₛₓ * exp(-Eaₛₓ/(fp.R * (273.15 + Tₛ))))
	Resp = @. Vmaxₛₓ * MMₛₓ * MMₒ₂ * 2314.8148 # 2314 to convert mgC hr-1 to umol s-1
end
