module DAMMmodel

using Statistics
using LsqFit

include("DAMM.jl")
include("quantilebins.jl")
include("DAMMfit.jl")
export DAMM, qbin, fitDAMM

end
