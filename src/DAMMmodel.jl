module DAMMmodel

using Statistics
using LsqFit
using DataFrames
using SparseArrays
using UnicodeFun
using GLMakie
using Unitful: R, L, mol, K, kJ, °C, m, g, cm, hr, mg, s, μmol
using UnitfulMoles: molC
using Unitful, UnitfulMoles
@compound CO₂

include(joinpath("constructors", "constants.jl"))
include(joinpath("constructors", "constructors.jl"))
include(joinpath("functions", "maths", "DAMM.jl"))
include(joinpath("functions", "maths", "DAMMfit.jl"))
include(joinpath("functions", "maths", "DAMMmat.jl"))
include(joinpath("functions", "viz", "DAMMplot.jl"))
include(joinpath("functions", "viz", "DAMMviz.jl"))
include(joinpath("functions", "maths", "qbins.jl"))
export DAMM, DAMMfit, DAMMmat, DAMMplot, DAMMviz, qbins, sDAMMmat, sDAMMmatq, molCO₂

end
