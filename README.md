# DAMMmodel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/stable)
[![DAMMmodel Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/DAMMmodel)](https://pkgs.genieframework.com?packages=DAMMmodel)
![version](https://img.shields.io/badge/version-0.1.13-green)
<!--- [![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/dev) 
[![Coverage](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl) --->

**Estimates CO<sub>2</sub> efflux (e.g., soil respiration (R<sub>s</sub>), [&mu;mol m<sup>-2</sup> s<sup>-1</sup>]) as a function of temperature (e.g., soil temperature (T<sub>s</sub>), [°C]) and soil moisture (&theta;, [m<sup>3</sup> m<sup>-3</sup>]).**

## Installation

Install with the Julia package manager [Pkg](https://pkgdocs.julialang.org/), just like any other registered Julia package:

```jl
julia> ]
pkg> add DAMMmodel
```
or
```jl
julia> using Pkg; Pkg.add("DAMMmodel")
```

## Usage

This package models respiration (CO<sub>2</sub> efflux, e.g., soil respiration (R<sub>s</sub>)) as a function of soil temperature (T<sub>s</sub>) and soil moisture (&theta;), using 
the [Dual Arrhenius and Michaelis-Menten](https://doi.org/10.1111/j.1365-2486.2011.02546.x) kinetics model (2012). 

The package contains six functions: `DAMMviz`, `DAMMfdata`, `DAMM`, `DAMMfit`, `DAMMmat`, and `DAMMplot`. 

### Examples
#### DAMMviz
    DAMMviz()
Interactive plot of the DAMM model

```jl
julia> DAMMviz()
```
![DAMMviz_v0 1 2](https://user-images.githubusercontent.com/22160257/149199698-0a858290-475f-4d49-b724-d07dd042e377.gif)
#### DAMMfdata
    DAMMfdata(n)
Generates a DataFrame of n fake data Tₛ, θ and Rₛ 

```jl
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
```
#### DAMM
    DAMM(x::VecOrMat{<: Real}, p::NTuple{7, Float64})
Calculate respiration as a function of soil temperature (Tₛ) and moisture (θ).

```jl
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
#### DAMMfit
    DAMMfit(x::VecOrMat{<: Real}, Rₛ::Vector{Float64}, poro_val::Float64)
fit the DAMM model parameters to data. 

```jl
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
#### DAMMmat
    DAMMmat(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)
Generates a matrix of DAMM output for gridded inputs x and y Inputs: 
soil temperature (Tₛ), soil moisture (θ), respiration (R), resolution (r)

```jl
julia> Tₛ = collect(15.0:2.5:40.0)
julia> θ = collect(0.2:0.05:0.7)
julia> R = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]
julia> r = 10
julia> poro_val, params, x, y, DAMM_Matrix = DAMMmat(Tₛ, θ, R, r)
```
    DAMMmat(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64, n::Int64)
Bin data by n quantiles

```jl
julia> n = 4
julia> poro_val, Tmed, θmed, Rmed, params, x, y, DAMM_Matrix = DAMMmat(Tₛ, θ, R, r, n)
```
#### DAMMplot
    DAMMplot(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)
Plot scatter of data and fitted DAMM surface

```jl
julia> df = DAMMfdata(100)
100×3 DataFrame
 Row │ Tₛ       θ        Rₛ       
     │ Float64  Float64  Float64  
─────┼────────────────────────────
   1 │    31.8      0.3  6.54735
   2 │    14.6      0.3  3.49235
  ⋮  │    ⋮        ⋮        ⋮
  99 │    17.2      0.4  0.880441
 100 │     5.2      0.2  0.0
julia> r = 50
julia> fig = DAMMplot(df.Tₛ, df.θ, df.Rₛ, r)
```
![DAMMplot_v0 1 14](https://user-images.githubusercontent.com/22160257/152836382-14beb21d-0df2-4801-a610-609cc00a1360.png)
#### qbin
    qbin(x, y, z, n)
Bins x into n quantiles, each xbin into n quantiles of y, return z quantile

```jl
julia> df = DataFrame(x=1:20, y=6:25, z=11:30)
julia> xmed, ymed, zmed = qbin(df.T, df.M, df.R, 3)
  xmed = [9, 9, 9, 15, 15, 15, 21, 21, 21]
  ymed = [12, 14, 16, 19, 20.5, 22, 25, 27, 29]
  zmed = [2, 4, 6, 8.5, 10.5, 15, 17, 19]
```
## Contributing

Issues and pull requests are welcome!
