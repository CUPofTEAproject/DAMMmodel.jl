var documenterSearchIndex = {"docs":
[{"location":"test/#test","page":"test","title":"test","text":"","category":"section"},{"location":"test/","page":"test","title":"test","text":"hello!","category":"page"},{"location":"test/","page":"test","title":"test","text":"<iframe src=\"https://clima.westus3.cloudapp.azure.com/jsserve/\" width=\"500\" height=\"500\">\n</iframe>","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = DAMMmodel","category":"page"},{"location":"#DAMMmodel","page":"Home","title":"DAMMmodel","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [DAMMmodel]","category":"page"},{"location":"#DAMMmodel.sDAMMmat","page":"Home","title":"DAMMmodel.sDAMMmat","text":"struct sDAMMmat\n\nFields required to plot surface of DAMM\n\nFields\n\nporosity::Float64\nparams::NTuple{7, Float64}\nx::Vector{Float64}\ny::Vector{Float64}\nDAMM_Matrix::Matrix{Float64}\n\n\n\n\n\n","category":"type"},{"location":"#DAMMmodel.sDAMMmatq","page":"Home","title":"DAMMmodel.sDAMMmatq","text":"struct sDAMMmatq\n\nFields required to plot surface of DAMM\n\nFields\n\nporosity::Float64\nTmed::Vector{Float64}\nθmed::Vector{Float64}\nRmed::Vector{Float64}\nparams::NTuple{7, Float64}\nx::Vector{Float64}\ny::Vector{Float64}\nDAMM_Matrix::Matrix{Float64}\n\n\n\n\n\n","category":"type"},{"location":"#DAMMmodel.DAMM-Tuple{VecOrMat{<:Real}, NTuple{7, Float64}}","page":"Home","title":"DAMMmodel.DAMM","text":"DAMM(x::VecOrMat{<: Real}, p::NTuple{7, Float64})\n\nCalculate respiration as a function of soil temperature (Tₛ) and moisture (θ).\n\nExamples\n\njulia> df = DAMMfdata(100) # generates a fake dataset\n100×3 DataFrame\n Row │ Tₛ       θ        Rₛ        \n     │ Float64  Float64  Float64   \n─────┼─────────────────────────────\n   1 │    15.5      0.3   1.72216\n   2 │    22.3      0.6   1.8213\n  ⋮  │    ⋮        ⋮         ⋮\n  99 │     9.5      0.2   0.223677\n 100 │     6.6      0.6   0.730627\njulia> fp # parameters: αₛₓ, Eaₛₓ, kMₛₓ, kMₒ₂, Sxₜₒₜ, Q10kM\n(1.0e9, 64.0, 3.46e-8, 0.002, 0.7, 0.02, 1.0)\njulia> DAMM(hcat(df.Tₛ, df.θ), fp) # μmolCO₂ m⁻² s⁻¹\n100-element Vector{Float64}:\n 6.023429035220588\n 0.9298933641647085\n ⋮\n 0.8444248717855868\n 3.805243237387702\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMfdata-Tuple{Any}","page":"Home","title":"DAMMmodel.DAMMfdata","text":"DAMMfdata(n)\n\nGenerates a DataFrame of n fake data Tₛ, θ and Rₛ \n\nExamples\n\n```julia-repl julia> DAMMfdata(5) 5×3 DataFrame  Row │ Tₛ       θ        Rₛ            │ Float64  Float64  Float64  ─────┼───────────────────────────    1 │    10.8      0.3  2.04327    2 │    31.5      0.1  7.8925    3 │    38.7      0.7  1.6    4 │    35.7      0.3  7.38025    5 │    21.9      0.2  3.0012\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMfit-Tuple{VecOrMat{<:Real}, Vector{Float64}, Float64}","page":"Home","title":"DAMMmodel.DAMMfit","text":"DAMMfit(x::VecOrMat{<: Real}, Rₛ::Vector{Float64}, poro_val::Float64)\n\nFit the DAMM model parameters to data. \n\nExamples\n\njulia> df = DAMMfdata(100) # generates a fake dataset\n100×3 DataFrame\n Row │ Tₛ       θ        Rₛ        \n     │ Float64  Float64  Float64   \n─────┼─────────────────────────────\n   1 │    27.1      0.3   4.345\n   2 │    38.7      0.6  12.0106\n  ⋮  │    ⋮        ⋮         ⋮\n  99 │    18.6      0.5   0.894257\n 100 │    19.4      0.4   3.79532\njulia> p = DAMMfit(hcat(df.Tₛ, df.θ), df.Rₛ, 0.7) \n(2.034002955272664e10, 71.65411256289629, 9.903541279858033e-8, 0.003688664956456453, 0.7, 0.02, 1.0)\njulia> DAMM(hcat(df.Tₛ, df.θ), p)\n100-element Vector{Float64}:\n  4.233540174412755\n 10.41149919818871\n  ⋮\n  1.746141124513421\n  1.9599317903590014\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMmat-Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}, Int64}","page":"Home","title":"DAMMmodel.DAMMmat","text":"DAMMmat(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, Rₛ::Array{Float64, 1}, r::Int64)\n\nGenerates a matrix of DAMM output for gridded inputs x and y Inputs: soil temperature (Tₛ), soil moisture (θ), respiration (Rₛ), resolution (r)\n\nExamples:\n\njulia> Tₛ = collect(15.0:2.5:40.0)\njulia> θ = collect(0.2:0.05:0.7)\njulia> Rₛ = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]\njulia> r = 10\njulia> out = DAMMmat(Tₛ, θ, Rₛ, r)\n\nDAMMmat(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, Rₛ::Array{Float64, 1}, r::Int64, n::Int64)\n\nBin data by n quantiles \n\nExamples:\n\njulia> n = 4\njulia> out = DAMMmat(Tₛ, θ, Rₛ, r, n)\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMplot-Tuple{Vector{Float64}, Vector{Float64}, Vector{Float64}, Int64}","page":"Home","title":"DAMMmodel.DAMMplot","text":"DAMMplot(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, Rₛ::Array{Float64, 1}, r::Int64)\n\nPlot scatter of data and fitted DAMM surface\n\nExample\n\njulia> df = DAMMfdata(100)\njulia> r = 50\njulia> fig = DAMMplot(df.Tₛ, df.θ, df.Rₛ, r)\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.DAMMviz-Tuple{}","page":"Home","title":"DAMMmodel.DAMMviz","text":"DAMMviz()\n\nInteractive plot of the DAMM model\n\nTo open\n\njulia> DAMMviz()\n\n\n\n\n\n","category":"method"},{"location":"#DAMMmodel.qbins-NTuple{4, Any}","page":"Home","title":"DAMMmodel.qbins","text":"qbins(x, y, z, n)\n\nBins x into n quantiles, each xbin into n quantiles of y, return z quantile\n\nExamples\n\njulia> df = DataFrame(x=1:20, y=6:25, z=11:30)\njulia> xmed, ymed, zmed = qbins(df.T, df.M, df.R, 3)\n  xmed = [9, 9, 9, 15, 15, 15, 21, 21, 21]\n  ymed = [12, 14, 16, 19, 20.5, 22, 25, 27, 29]\n  zmed = [2, 4, 6, 8.5, 10.5, 15, 17, 19]\n\n\n\n\n\n","category":"method"}]
}
