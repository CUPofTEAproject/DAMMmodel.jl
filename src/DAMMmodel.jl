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

include("constants.jl")
include("DAMM.jl")
include("DAMMfit.jl")
include("DAMMmat.jl")
include("DAMMplot.jl")
include("DAMMviz.jl")
include("qbins.jl")
export DAMM, DAMMfit, DAMMmat, DAMMplot, DAMMviz, qbins

end
