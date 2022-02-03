using DAMMmodel
using Test

@testset verbose = true "DAMMmodel Tests" begin    
  @testset "DAMM.jl" begin
    @test typeof(DAMM(hcat(fake.Tₛ, fake.θ), fake.p)) == Vector{Float64} 
  end
  @testset "DAMMfit.jl" begin   
    @test typeof(DAMMfit(hcat(fake.Tₛ, fake.θ), fake.Rₛ, 0.7)) == NTuple{7, Float64}
  end
end
