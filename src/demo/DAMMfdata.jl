const fp = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.7, 0.02, 1.0)

"""
    DAMMfdata(n)

Generates a DataFrame of n fake data Tₛ, θ and Rₛ 

# Examples
```julia-repl
julia> DAMMfdata(5)
5×3 DataFrame
 Row │ Tₛ       θ        Rₛ      
     │ Float64  Float64  Float64 
─────┼───────────────────────────
   1 │    10.8      0.3  2.04327
   2 │    31.5      0.1  7.8925
   3 │    38.7      0.7  1.6
   4 │    35.7      0.3  7.38025
   5 │    21.9      0.2  3.0012
"""
function DAMMfdata(n)
  Tₛ = rand(0:400, n)./10  
  θ = rand(1:7, n)./10
  noise = rand(-20:20, n)./10
  Rₛ = DAMM(hcat(Tₛ, θ), fp) .+ noise 
  Rₛ[Rₛ .< 0] .= 0
  df = DataFrame((Tₛ = Tₛ, θ = θ, Rₛ = Rₛ)) 
  return df
end
