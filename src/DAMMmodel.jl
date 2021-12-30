module DAMMmodel

using Statistics
using LsqFit
using DataFrames
using SparseArrays
using UnicodeFun
using GLMakie

include("DAMM.jl")
include("DAMMfit.jl")
include("DAMMmat.jl")
include("DAMMplot.jl")
include("DAMMviz.jl")
include("qbins.jl")
export DAMM, DAMMfit, DAMMmat, DAMMplot, DAMMviz, qbins

end
