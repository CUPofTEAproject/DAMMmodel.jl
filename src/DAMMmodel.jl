module DAMMmodel

using Statistics
using LsqFit
using DataFrames
using SparseArrays
using UnicodeFun

include("DAMM.jl")
include("quantilebins.jl")
include("DAMMfit.jl")
export DAMM, qbin, fitDAMM

end
