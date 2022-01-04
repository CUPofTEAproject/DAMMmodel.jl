#=
using GLMakie, SparseArrays, UnicodeFun, DAMMmodel

TO DO checkbox list:
[x] adjust color scales
[x] adjust sliders range
[] interactivity for porosity
[x] increase font size
[] add a "parameter" title and "isoline" title above sliders
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
  fontsize_theme = Theme(fontsize = 30)
  set_theme!(fontsize_theme)

  fig = Figure(resolution = (2000, 1800))
  ax3D = Axis3(fig[1, 2])
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
    1e8:1e8:1e9, # α or p[1]  
    58:1:70, # Ea p[2]
    1e-9:1e-6:1e-5, # kMsx p[3]
    1e-4:1e-3:1e-2, # kMo2 p[4]
    0.3:0.05:0.8, # porosity p[5]
    0.01:0.01:0.1, # sx, p[6]
    0:2:40, # Ts
    0:0.02:0.7 # θ
   ]; #
  sliders = [Slider(fig, range = sr) for sr in sliderranges];
  texts[1] = Label(fig, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[1].value), textsize=30, width = Auto(false));
  texts[2] = Label(fig, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[2].value), textsize=30, width = Auto(false));
  texts[3] = Label(fig, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[3].value), textsize=30, width = Auto(false));
  texts[4] = Label(fig, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[4].value), textsize=30, width = Auto(false));
  texts[5] = Label(fig, text= lift(X->string(to_latex("Porosity"), " = ", X, to_latex(" (m^3 m^{-3})")), sliders[5].value), textsize=30, width = Auto(false));
  texts[6] = Label(fig, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[6].value), textsize=30, width = Auto(false));
  texts[7] = Label(fig, text= lift(X->string(to_latex("T_s"), " = ", X, to_latex(" (°C)")), sliders[7].value), textsize=30, width = Auto(false));
  texts[8] = Label(fig, text= lift(X->string(to_latex("θ"), " = ", X, to_latex(" (m^3 m^{-3})")), sliders[8].value), textsize=30, width = Auto(false));
  vertical_sublayout = fig[1, 1] = vgrid!(
    Iterators.flatten(zip(texts, sliders))...;
   ) #width = 200, height = 1000);

  αsx = sliders[1].value
  set_close_to!(sliders[1], 6e8)
  Ea = sliders[2].value
  set_close_to!(sliders[2], 64)
  kMsx = sliders[3].value
  set_close_to!(sliders[3], 5e-6)
  kMo2 = sliders[4].value
  set_close_to!(sliders[4], 0.004)
  porosity = sliders[5].value
  set_close_to!(sliders[5], 0.5)
  sx = sliders[6].value
  set_close_to!(sliders[6], 0.05)
  Ts = sliders[7].value
  set_close_to!(sliders[7], 38)
  θ = sliders[8].value 
  set_close_to!(sliders[8], 0.4)

  params = @lift([$αsx, $Ea, $kMsx, $kMo2, 0.7, $sx])
  DAMM_Matrix = @lift(Matrix(sparse(X, Y, DAMM(xy, $params))))
  
  s3D = surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral),
	transparency = true, alpha = 0.01, shading = false, colorrange = (0, 30))
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true,
	transparency = true, color = (:black, 0.1));
  point = @lift(DAMM(hcat($Ts, $θ), $params))
  point3D = @lift(Vec3f0.($Ts, $θ, $point))
  scatter3D = scatter!(ax3D, point3D, markersize = 8000, color = :black)
  Colorbar(fig[1, 3], colormap = Reverse(:Spectral), limits = (0, 30),
	   label = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})")); 
	
  ax2D = Axis(fig[2, 1])
  isoθ = @lift(collect(range($θ, length=length(x), stop=$θ)))
  isoy = @lift(DAMM(hcat(x, $isoθ), $params))
  lines!(ax2D, x, isoy, color = isoy, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  pointTs2D = @lift(Point2f0.($Ts, $point))
  scatter!(ax2D, pointTs2D, color = :black, markersize = 20)
	
  ax2D2 = Axis(fig[2, 2:3])
  isoT = @lift(collect(range($Ts, length=length(x), stop=$Ts)))
  isox = @lift(DAMM(hcat($isoT, y), $params))
  lines!(ax2D2, y, isox, color = isox, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  pointθ2D = @lift(Point2f0.($θ, $point))
  scatter!(ax2D2, pointθ2D, color = :black, markersize = 20)

  # isoline in the 3D figure
  lines!(ax3D, x, isoθ, isoy, color = isoy, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  # lines!(ax3D, x .+1, isoθ, isoy, linewidth = 1, color = :black)
  # lines!(ax3D, x .-1, isoθ, isoy, linewidth = 1, color = :black)

  lines!(ax3D, isoT, y, isox, color = isox, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))

  ylims!(ax2D, 0.0, 30.0); xlims!(ax2D, 10.0, 40.0);
  ylims!(ax2D2, 0.0, 30.0); xlims!(ax2D2, 0.0, 0.8);
  zlims!(ax3D, 0.0, 30.0);

  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");

  ax2D.xlabel = to_latex("T_{soil} (°C)");
  ax2D.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  # ax2D2.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  hideydecorations!(ax2D2, ticks = false)
  ax2D2.xlabel = to_latex("\\theta (m^3 m^{-3})");

  #FZ = 30; ax2D.xlabelsize = FZ; ax2D.ylabelsize = FZ; ax2D2.xlabelsize = FZ; ax2D2.ylabelsize = FZ;
  #ax2D.xticklabelsize = FZ; ax2D.yticklabelsize = FZ; ax2D2.xticklabelsize = FZ; ax2D2.yticklabelsize = FZ;
  colsize!(fig.layout, 1, Relative(1/2))
  fig
  return fig
end


