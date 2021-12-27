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

## Contributing

Issues and pull requests are welcome!
