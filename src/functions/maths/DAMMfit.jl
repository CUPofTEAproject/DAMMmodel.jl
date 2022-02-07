"""
    DAMMfit(x::VecOrMat{<: Real}, Rₛ::Vector{Float64}, poro_val::Float64)

Fit the DAMM model parameters to data. 

# Examples
```julia-repl
julia> df = DAMMfdata(100) # generates a fake dataset
100×3 DataFrame
 Row │ Tₛ       θ        Rₛ        
     │ Float64  Float64  Float64   
─────┼─────────────────────────────
   1 │    27.1      0.3   4.345
   2 │    38.7      0.6  12.0106
  ⋮  │    ⋮        ⋮         ⋮
  99 │    18.6      0.5   0.894257
 100 │    19.4      0.4   3.79532
julia> p = DAMMfit(hcat(df.Tₛ, df.θ), df.Rₛ, 0.7) 
(2.034002955272664e10, 71.65411256289629, 9.903541279858033e-8, 0.003688664956456453, 0.7, 0.02, 1.0)
julia> DAMM(hcat(df.Tₛ, df.θ), p)
100-element Vector{Float64}:
  4.233540174412755
 10.41149919818871
  ⋮
  1.746141124513421
  1.9599317903590014
```
"""
function DAMMfit(x::VecOrMat{<: Real}, Rₛ::Vector{Float64}, poro_val::Float64)
  lb = [0.0, 0.0, 0.0, 0.0] # params can't be negative
  p_ini = [1.0, 6.4, 1.0, 1.0] # initial parameters
  p_fact = (1e9, 1e1, 1e-6, 1e-4, 1.0, 1.0, 1.0) # factor of param, better fit
  DAMMfix = (x, p) -> DAMM(x, p_fact.*(p[1], p[2], p[3], p[4], poro_val, 0.02, 1.0))
  fit_bounds = curve_fit(DAMMfix, x, Rₛ, p_ini, lower=lb)
  p = fit_bounds.param # fitted param result 
  fparam = p_fact[1:4].*p # multiply them by p_fact
  params = (fparam[1], fparam[2], fparam[3], fparam[4], poro_val, 0.02, 1.0)
  return params
end
