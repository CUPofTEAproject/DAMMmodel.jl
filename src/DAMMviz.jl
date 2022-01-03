using GLMakie

#=
using GLMakie, SparseArrays, UnicodeFun, DAMMmodel

TO DO checkbox list:
[] adjust color scales
[] adjust sliders range
[] interactivity for porosity
=#

"""
    DAMMviz()

Interactive plot of the DAMM model

# To open
```julia-repl
julia> DAMMviz()
```
"""
function DAMMviz()
  fig = Figure(resolution = (1800, 1000))
  ax3D = Axis3(fig[1:2, 2])
  r = 50
  x = collect(range(0, length=r, stop=40)) # T axis, °C from min to max
  y = collect(range(0, length=r, stop=0.7)) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix 
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on   
  Y2 = repeat(y, outer=r) # M values to fit DAMM on
  xy = hcat(X2, Y2) # T and M matrix to create DAMM matrix 

  texts = Array{Label}(undef, 8);
  sliderranges = [
    1e7:1e8:1e9, # α or p[1]  
    50:1:70, # Ea p[2]
    1e-9:1e-8:1e-7, # kMsx p[3]
    1e-4:1e-3:1e-2, # kMo2 p[4]
    0.3:0.05:0.8, # porosity p[5]
    0.01:0.01:0.1, # sx, p[6]
    0:2:40, # Ts
    0:0.1:0.7 # θ
   ]; #
  sliders = [Slider(fig, range = sr) for sr in sliderranges];
  texts[1] = Label(fig, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[1].value), textsize=15, width = Auto(false));
  texts[2] = Label(fig, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[2].value), textsize=15, width = Auto(false));
  texts[3] = Label(fig, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[3].value), textsize=15, width = Auto(false));
  texts[4] = Label(fig, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[4].value), textsize=15, width = Auto(false));
  texts[5] = Label(fig, text= lift(X->string(to_latex("Porosity"), " = ", X, to_latex(" (m^3 m^{-3})")), sliders[5].value), textsize=15, width = Auto(false));
  texts[6] = Label(fig, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[6].value), textsize=15, width = Auto(false));
  texts[7] = Label(fig, text= lift(X->string(to_latex("T_s"), " = ", X, to_latex(" (°C)")), sliders[7].value), textsize=15, width = Auto(false));
  texts[8] = Label(fig, text= lift(X->string(to_latex("θ"), " = ", X, to_latex(" (m^3 m^{-3})")), sliders[8].value), textsize=15, width = Auto(false));
  vertical_sublayout = fig[1:2, 1] = vgrid!(
    Iterators.flatten(zip(texts, sliders))...;
    width = 200, height = 1000);

  αsx = sliders[1].value
  Ea = sliders[2].value
  kMsx = sliders[3].value
  kMo2 = sliders[4].value
  porosity = sliders[5].value
  sx = sliders[6].value
  Ts = sliders[7].value
  θ = sliders[8].value

  params = @lift([$αsx, $Ea, $kMsx, $kMo2, 0.7, $sx])
  DAMM_Matrix = @lift(Matrix(sparse(X, Y, DAMM(xy, $params))))
  
  s3D = surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral),
	transparency = true, alpha = 0.1, shading = false)
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true,
	transparency = true, color = (:black, 0.1));
  Colorbar(fig[1:2, 3], colormap = Reverse(:Spectral), limits = (0, 10),
	   label = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})")); 
	
  ax2D = Axis(fig[1, 4])
  isoθ = @lift(collect(range($θ, length=length(x), stop=$θ)))
  isoy = @lift(DAMM(hcat(x, $isoθ), $params))
  lines!(ax2D, x, isoy, color = isoy, linewidth = 8, colormap = Reverse(:Spectral))
	
  ax2D2 = Axis(fig[2, 4])
  isoT = @lift(collect(range($Ts, length=length(x), stop=$Ts)))
  isox = @lift(DAMM(hcat($isoT, y), $params))
  lines!(ax2D2, y, isox, color = isox, linewidth = 8, colormap = Reverse(:Spectral))

  # isoline in the 3D figure
  lines!(ax3D, x, isoθ, isoy, color = isoy, linewidth = 8, colormap = Reverse(:Spectral))

  lines!(ax3D, isoT, y, isox, color = isox, linewidth = 8, colormap = Reverse(:Spectral))

  ylims!(ax2D, 0.0, 30.0); xlims!(ax2D, 10.0, 35.0);
  ylims!(ax2D2, 0.0, 30.0); xlims!(ax2D2, 0.0, 0.8);

  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");

  ax2D.xlabel = to_latex("T_{soil} (°C)");
  ax2D.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  ax2D2.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  ax2D2.xlabel = to_latex("\\theta (m^3 m^{-3})");
 
  #FZ = 30; ax2D.xlabelsize = FZ; ax2D.ylabelsize = FZ; ax2D2.xlabelsize = FZ; ax2D2.ylabelsize = FZ;
  #ax2D.xticklabelsize = FZ; ax2D.yticklabelsize = FZ; ax2D2.xticklabelsize = FZ; ax2D2.yticklabelsize = FZ;
  fig
  return fig
end

