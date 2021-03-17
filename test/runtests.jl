using DAMMmodel
using Test

@testset "DAMMmodel.jl" begin
    # Write your tests here.
    # Testing DAMM.jl
	x = [18.0 0.35; 22.0 0.22] # Ind variables test
	p = [1e8, 62, 3.46e-8, 2.0e-3, 0.4, 0.0125] # Parameters test
	DAMMmodel.DAMM(x, p) # DAMM test
end
