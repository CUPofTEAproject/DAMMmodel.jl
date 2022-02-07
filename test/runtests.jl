using DAMMmodel
using Test

@testset verbose = true "DAMMmodel" begin    
  @testset "DAMM.jl" begin
    df = DAMMfdata(10)
    @test typeof(DAMM(hcat(df.Tₛ, df.θ), fp)) == Vector{Float64} 
  end
  @testset "DAMMfit.jl" begin
    df = DAMMfdata(10)
    @test typeof(DAMMfit(hcat(df.Tₛ, df.θ), df.Rₛ, 0.7)) == NTuple{7, Float64}
  end
end
