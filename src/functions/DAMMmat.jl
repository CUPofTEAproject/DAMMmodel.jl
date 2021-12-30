"""
    DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)

Generates a matrix of DAMM output for gridded inputs x and y
Inputs: soil temperature (Ts), soil moisture (θ), respiration (R), resolution (r)

# Examples: 
```julia-repl
julia> Ts = collect(15.0:2.5:40.0)
julia> θ = collect(0.2:0.05:0.7)
julia> R = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]
julia> r = 10
julia> poro_val, params, x, y, DAMM_Matrix = DAMMmat(Ts, θ, R, r)
```

    DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64, n::Int64)

Bin data by n quantiles 

# Examples: 
```julia-repl
julia> n = 4
julia> poro_val, Tmed, θmed, Rmed, params, x, y, DAMM_Matrix = DAMMmat(Ts, θ, R, r, n)
```
"""
function DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)   
  poro_val = maximum(θ)
  params = fitDAMM(hcat(Ts, θ), R, poro_val)  
# create x y arrays, and z matrix, to plot DAMM surface
  x = collect(range(minimum(Ts), length=r, stop=maximum(Ts))) # T axis, °C from min to max
  y = collect(range(minimum(θ), length=r, stop=maximum(θ))) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  return poro_val, params, x, y, DAMM_Matrix
end

function DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64, n::Int64)   
  Tmed, θmed, Rmed = qbin(Ts, θ, R, n)
  poro_val = maximum(θ)
  params = fitDAMM(hcat(Tmed, θmed), Rmed, poro_val)  
# create x y arrays, and z matrix, to plot DAMM surface
  x = collect(range(minimum(Tmed), length=r, stop=maximum(Tmed))) # T axis, °C from min to max
  y = collect(range(minimum(θmed), length=r, stop=maximum(θmed))) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 
  DAMM_Matrix = Matrix(sparse(X, Y, DAMM(xy, params)))
  return poro_val, Tmed, θmed, Rmed, params, x, y, DAMM_Matrix
end

#= 
using DataFrames, DAMMmodel, Statistics, SparseArrays 
=#
