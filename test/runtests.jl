using DAMMmodel
using Test

@testset "DAMMmodel.jl" begin
    # Write your tests here.
	x = [18.0 0.3; 22.0 0.22]
	p = [62.0, 1e8, 2.0e-3, 3.46e-8]
	DAMM(x, p)
end
