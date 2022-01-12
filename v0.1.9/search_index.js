var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = DAMMmodel","category":"page"},{"location":"#DAMMmodel","page":"Home","title":"DAMMmodel","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [DAMMmodel]","category":"page"},{"location":"#DAMMmodel.DAMM-Tuple{VecOrMat{<:Real}, NTuple{6, Float64}}","page":"Home","title":"DAMMmodel.DAMM","text":"DAMM(x::VecOrMat{<: Real}, p::NTuple{6, Float64})\n\nCalculate respiration as a function of soil temperature and moisture.\n\nExamples\n\njulia> Tₛ = [18.0, 22.0] # soil temperature [°C]\njulia> θ = [0.35, 0.22] # soil moisture [m³ m⁻³]\njulia> x = hcat(Tₛ, θ)\njulia> p = (1e9, 64.0, 3.46e-8, 2.0e-3, 0.4, 0.0125) # αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, Sxₜₒₜ\njulia> DAMM(x, p)\n  1.6 # μmolCO₂ m⁻² s⁻¹ \n  2.8 # μmolCO₂ m⁻² s⁻¹\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMfit-Tuple{Any, Any, Any}","page":"Home","title":"DAMMmodel.DAMMfit","text":"DAMMfit(Ind_var, Resp, poro_val)\n\nfit the DAMM model parameters to data. \n\nExamples\n\njulia> Tₛ = [19.0, 22.0] # soil temperature [°C]\njulia> θ = [0.35, 0.22] # soil moisture [m³ m⁻³]\njulia> Rₛ = [2.2, 2.8] # respiration observation\njulia> Ind_var = hcat(Tₛ, θ)\njulia> p = DAMMfit(Ind_var, Rₛ, 0.4) \n  3.533e8\n 63.604\n  2.489e-10\n  0.005\n  0.4\n  0.02\njulia> DAMM(Ind_var, p)\n  2\n  4\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMmat-Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}, Int64}","page":"Home","title":"DAMMmodel.DAMMmat","text":"DAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)\n\nGenerates a matrix of DAMM output for gridded inputs x and y Inputs: soil temperature (Ts), soil moisture (θ), respiration (R), resolution (r)\n\nExamples:\n\njulia> Ts = collect(15.0:2.5:40.0)\njulia> θ = collect(0.2:0.05:0.7)\njulia> Rₛ = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]\njulia> r = 10\njulia> out = DAMMmat(Ts, θ, Rₛ, r)\n\nDAMMmat(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64, n::Int64)\n\nBin data by n quantiles \n\nExamples:\n\njulia> n = 4\njulia> out = DAMMmat(Ts, θ, Rₛ, r, n)\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMplot-Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}, Int64}","page":"Home","title":"DAMMmodel.DAMMplot","text":"DAMMplot(Ts::Array{Float64, 1}, θ::Array{Float64, 1}, R::Array{Float64, 1}, r::Int64)\n\nPlot scatter of data and fitted DAMM surface\n\nExample\n\njulia> Ts = collect(15.0:2.5:40.0)\njulia> θ = collect(0.2:0.05:0.7)\njulia> Rₛ = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]\njulia> r = 10\njulia> fig = DAMMplot(Ts, θ, Rₛ, r)\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMviz-Tuple{}","page":"Home","title":"DAMMmodel.DAMMviz","text":"DAMMviz()\n\nInteractive plot of the DAMM model\n\nTo open\n\njulia> DAMMviz()\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.qbins-NTuple{4, Any}","page":"Home","title":"DAMMmodel.qbins","text":"qbins(x, y, z, n)\n\nBins x into n quantiles, each xbin into n quantiles of y, return z quantile\n\nExamples\n\njulia> df = DataFrame(x=1:20, y=6:25, z=11:30)\njulia> xmed, ymed, zmed = qbins(df.T, df.M, df.R, 3)\n  xmed = [9, 9, 9, 15, 15, 15, 21, 21, 21]\n  ymed = [12, 14, 16, 19, 20.5, 22, 25, 27, 29]\n  zmed = [2, 4, 6, 8.5, 10.5, 15, 17, 19]\n\n\n\n\n\n","category":"method"}]
}
