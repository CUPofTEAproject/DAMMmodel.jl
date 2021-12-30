# DAMMmodel

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://CUPofTEAproject.github.io/DAMMmodel.jl/dev)
[![Coverage](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/CUPofTEAproject/DAMMmodel.jl)

**DAMMmodel estimates respiration CO2 efflux as a function of soil temperature and soil moisture.**

## Installation

Install with the Julia package manager [Pkg](https://pkgdocs.julialang.org/), just like any other registered Julia package:

```jl
pkg> add DAMMmodel  # Press ']' to enter the Pkg REPL mode.
```
or
```jl
julia> using Pkg; Pkg.add("DAMMmodel")
```

## Usage

This package models respiration CO2 flux as a function of soil temperature and soil moisture, using 
the [Dual Arrhenius and Michaelis-Menten](https://doi.org/10.1111/j.1365-2486.2011.02546.x) kinetics model (2012). 

To install, just type `]add DAMMmodel` in a Julia REPL. 

The package contains three functions: `DAMM`, `qbin`, and `fitDAMM`. 

### Examples
#### DAMM
    DAMM(x, p)
Calculate respiration as a function of soil temperature and moisture.

```jl
julia> Ts = [18.0, 22.0] # 2 values soil temperature [°C]
julia> SWC = [0.35, 0.22] # 2 values of soil moisture [m3m-3]
julia> x = hcat(Ts, SWC)
julia> p = [1e8, 62, 3.46e-8, 2.0e-3, 0.4, 0.0125] # α, Ea, kMsx, kMO2, Sxtot
julia> DAMM(x, p)
  1.33
  2.33
```
#### fitDAMM
    fitDAMM(Ind_var, Resp, poro_val)
fit the DAMM model parameters to data. 

```jl
julia> Ts = [19.0, 22.0] # 2 values soil temperature [°C]
julia> SWC = [0.35, 0.22] # 2 values of soil moisture [m3m-3]
julia> Resp = [2, 4] # respiration observation
julia> Ind_var = hcat(Ts, SWC)
julia> p = fitDAMM(Ind_var, Resp, 0.4) # fitted params α, Ea, kMsx, kMO2, Sxtot
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