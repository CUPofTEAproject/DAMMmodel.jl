using DAMMmodel
using Test
using DataFrames
using GLMakie

@testset verbose = true "DAMMmodel" begin    
  @testset "DAMM()" begin
    df = DAMMfdata(10)
    @test typeof(DAMM(hcat(df.Tₛ, df.θ), fp)) == Vector{Float64} 
  end
  @testset "DAMMfit()" begin
    df = DAMMfdata(10)
    @test typeof(DAMMfit(hcat(df.Tₛ, df.θ), df.Rₛ, 0.7)) == NTuple{7, Float64}
  end
  @testset "DAMMviz()" begin
    @test typeof(DAMMviz()) == Makie.Figure
  end
  @testset "DAMMfdata()" begin
    @test typeof(DAMMfdata(5)) == DataFrames.DataFrame
  end
  @testset "DAMMmat()" begin
    df = DAMMfdata(10)
    @test typeof(DAMMmat(df.Tₛ, df.θ, df.Rₛ, 10)) == sDAMMmat
    @test typeof(DAMMmat(df.Tₛ, df.θ, df.Rₛ, 10, 2)) == sDAMMmatq
  end
  @testset "DAMMplot()" begin
    df = DAMMfdata(10)
    @test typeof(DAMMplot(df.Tₛ, df.θ, df.Rₛ, 10)) == Makie.Figure
  end
  @testset "qbins()" begin
    df = DAMMfdata(10)
    @test typeof(qbins(df.Tₛ, df.θ, df.Rₛ, 2)) == Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}}
    end
end
