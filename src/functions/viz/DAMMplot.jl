"""
    DAMMplot(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, Rₛ::Array{Float64, 1}, r::Int64)

Plot scatter of data and fitted DAMM surface

# Example
```julia-repl
julia> Tₛ = collect(15.0:2.5:40.0)
julia> θ = collect(0.2:0.05:0.7)
julia> Rₛ = [1.0, 1.2, 1.5, 2.0, 2.7, 3.8, 4.9, 6.7, 4.1, 2.0, 0.4]
julia> r = 10
julia> fig = DAMMplot(Tₛ, θ, Rₛ, r)
```
"""
function DAMMplot(Tₛ::Array{Float64, 1}, θ::Array{Float64, 1}, Rₛ::Array{Float64, 1}, r::Int64)
  fig = Figure()
  ax3D = Axis3(fig[1, 1])
  out = DAMMmat(Tₛ, θ, Rₛ, r)
  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  data3D = Vec3f.(Tₛ, θ, Rₛ)
  p3D = scatter!(ax3D, data3D, markersize = 2500, strokewidth = 3,
	color = Rₛ, colormap = Reverse(:Spectral))
  s3D = surface!(ax3D, out.x, out.y, out.DAMM_Matrix, colormap = Reverse(:Spectral),
	transparency = true, alpha = 0.1, shading = false)
  w3D = wireframe!(ax3D, out.x, out.y, out.DAMM_Matrix, overdraw = true,
	transparency = true, color = (:black, 0.1));
  Colorbar(fig[1, 2], colormap = Reverse(:Spectral),
	   label = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"));
  fig
  return fig
end

