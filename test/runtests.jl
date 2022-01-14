using DAMMmodel
using Test

@testset "DAMMmodel Tests" begin    
    # Testing DAMM.jl
	x = [18.0 0.35; 22.0 0.22] # Ind variables test
	p = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125) # Parameters test
	@test typeof(DAMM(x, p)) == Vector{Float64} # DAMM test
end
