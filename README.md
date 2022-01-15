# DAMMmodel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/dev)
[![Coverage](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl)
[![DAMMmodel Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/DAMMmodel)](https://pkgs.genieframework.com?packages=DAMMmodel)

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

The package contains five functions: `DAMMviz`, `DAMM`, `DAMMfit`, `DAMMmat`, and `DAMMplot`. 

### Examples
#### DAMMviz
    DAMMviz()
Interactive plot of the DAMM model

```jl
julia> DAMMviz()
```
![DAMMviz_v0 1 2](https://user-images.githubusercontent.com/22160257/149199698-0a858290-475f-4d49-b724-d07dd042e377.gif)
#### DAMM
    DAMM(x, p)
Calculate respiration as a function of soil temperature and moisture.

```jl
julia> Ts = [18.0, 22.0] # 2 values soil temperature [°C]
julia> SWC = [0.35, 0.22] # 2 values of soil moisture [m3 m-3]
julia> x = hcat(Ts, SWC)
julia> p = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125) # α, Ea, kMsx, kMO2, Sxtot
julia> DAMM(x, p)
  1.6
  2.8
```
#### DAMMfit
    DAMMfit(Ind_var, Resp, poro_val)
fit the DAMM model parameters to data. 

```jl
julia> Ts = [19.0, 22.0] # 2 values soil temperature [°C]
julia> SWC = [0.35, 0.22] # 2 values of soil moisture [m3 m-3]
julia> Resp = [2, 4] # respiration observation
julia> Ind_var = hcat(Ts, SWC)
julia> p = DAMMfit(Ind_var, Resp, 0.4) # fitted params α, Ea, kMsx, kMO2, Sxtot
  3.533e8
 63.604
  2.489e-10
  0.005
  0.4
  0.02
julia> DAMM(Ind_var, p)
  2
  4
```
#### DAMMmat
    DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)
Generates a matrix of DAMM output for gridded inputs x and y Inputs: 
soil temperature (Ts), soil moisture (θ), respiration (R), resolution (r)

```jl
julia> Ts = collect(15.0:2.5:40.0)
julia> θ = collect(0.2:0.05:0.7)
julia> R = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]
julia> r = 10
julia> poro_val, params, x, y, DAMM_Matrix = DAMMmat(Ts, θ, R, r)
```
    DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64, n::Int64)
Bin data by n quantiles

```jl
julia> n = 4
julia> poro_val, Tmed, θmed, Rmed, params, x, y, DAMM_Matrix = DAMMmat(Ts, θ, R, r, n)
```
#### DAMMplot
    DAMMplot(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)
Plot scatter of data and fitted DAMM surface

```jl
julia> Ts = collect(15.0:2.5:40.0)
julia> θ = collect(0.2:0.05:0.7)
julia> R = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]
julia> r = 10
julia> fig = DAMMplot(Ts, θ, R, r)
```
![DAMMplot](https://user-images.githubusercontent.com/22160257/149199780-74784291-3731-41d2-b087-2cb87b2d0efb.png)
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
