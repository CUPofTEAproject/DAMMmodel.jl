module DAMMmodel

using Makie
using AbstractPlotting.MakieLayout
using UnicodeFun
using LsqFit
using CSV
using SparseArrays

include("DAMM.jl")
include("DAMM_Makie.jl")
include("DAMM_LsqFit.jl")

end
