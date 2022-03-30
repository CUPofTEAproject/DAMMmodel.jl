"""
    DAMMviz()

Interactive plot of the DAMM model

# To open
```julia-repl
julia> DAMMviz()
```
"""
function DAMMviz(;width = 2200, height = 1600, fontsize = 30)
  fontsize_theme = Theme(fontsize = fontsize, font = "JuliaMono")
  set_theme!(fontsize_theme)

  fig = Figure(resolution = (width, height), figure_padding = 30)
  ax3D = Axis3(fig[1, 2])

  texts = Array{Label}(undef, 9);
  sliderranges = [
    1e8:1e8:1e9, # α or p[1]
    58.0:1.0:70.0, # Ea p[2]
    1e-9:1e-6:1e-5, # kMsx p[3]
    1e-4:1e-3:1e-2, # kMo2 p[4]
    0.3:0.05:0.8, # porosity p[5]
    0.01:0.01:0.1, # sx, p[6]
    0:2:40, # Ts
    0:0.02:0.8, # θ
    0.7:0.1:3.0 # Q10Km
   ]; #
  sliders = [Slider(fig, range = sr) for sr in sliderranges];
  texts[1] = Label(fig, text= lift(X->string("Parameters\n", to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[1].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[2] = Label(fig, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[2].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[3] = Label(fig, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[3].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[4] = Label(fig, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[4].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[5] = Label(fig, text= lift(X->string(to_latex("Porosity"), " = ", X, to_latex(" (m^3 m^{-3})")), sliders[5].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[6] = Label(fig, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[6].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));
  texts[7] = Label(fig, text= lift(X->string("Drivers\n", to_latex("T_s"), " = ", X, to_latex(" (°C)")), sliders[7].value), justification = :left, halign = :left, fontsize = fontsize, color = :green, width = Auto(false));
  texts[8] = Label(fig, text= lift(X->string(to_latex("θ"), " = ", round(X, sigdigits = 3), to_latex(" (m^3 m^{-3})")), sliders[8].value), justification = :left, halign = :left, fontsize = fontsize, color = :green, width = Auto(false));
  texts[9] = Label(fig, text= lift(X->string(to_latex("Q_{10} of kM_{sx}"), " = ", X, to_latex(" (-)")), sliders[9].value), justification = :left, halign = :left, fontsize = fontsize, width = Auto(false));

  αsx = sliders[1].value
  set_close_to!(sliders[1], 7e8)
  Ea = sliders[2].value
  set_close_to!(sliders[2], 61)
  kMsx = sliders[3].value
  set_close_to!(sliders[3], 5e-6)
  kMo2 = sliders[4].value
  set_close_to!(sliders[4], 0.004)
  porosity = sliders[5].value
  set_close_to!(sliders[5], 0.7)
  sx = sliders[6].value
  set_close_to!(sliders[6], 0.05)
  Ts = sliders[7].value
  set_close_to!(sliders[7], 28)
  θ = sliders[8].value
  set_close_to!(sliders[8], 0.4)
  Q10Km = sliders[9].value
  set_close_to!(sliders[9], 1.0)

  r = 50
  x = collect(range(0, length=r, stop=40)) # T axis, °C from min to max
  y = @lift(collect(range(0, length=r, stop=$porosity))) # M axis, % from min to max
  X = repeat(1:r, inner=r) # X for DAMM matrix
  Y = repeat(1:r, outer=r) # Y for DAMM matrix
  X2 = repeat(x, inner=r) # T values to fit DAMM on
  Y2 = @lift(repeat($y, outer=r)) # M values to fit DAMM on
  xy = @lift(hcat(X2, $Y2)) # T and M matrix to create DAMM matrix

  params = @lift(($αsx, $Ea, $kMsx, $kMo2, $porosity, $sx, $Q10Km))
  DAMM_Matrix = @lift(Matrix(sparse(X, Y, DAMM($xy, $params))))
  Rₛ = @lift(DAMM(hcat($Ts, $θ), $params))
  Rₛᵣ = @lift(round.($Rₛ, sigdigits = 3)[1])

  vertical_sublayout = fig[1, 1] = hgrid!(vgrid!(
  Iterators.flatten(zip(texts[vcat(1:6, 9)], sliders[vcat(1:6, 9)]))...;
   ),  #width = 200, height = 1000);
  #vertical_sublayout2 = fig[1, 2] =
  vgrid!(
  Iterators.flatten(zip(texts[7:8], sliders[7:8]))...,
  Label(fig, text = lift(X -> string("\n", to_latex("R_{s} = "), X, to_latex(" (\\mumol m^{-2} s^{-1})")), Rₛᵣ), color = :red, justification = :left, halign = :left, fontsize = fontsize, width = Auto(false))), halign = :left) #width = 200, height = 1000);

  s3D = surface!(ax3D, x, y, DAMM_Matrix, colormap = Reverse(:Spectral),
	transparency = true, alpha = 0.2, shading = false, colorrange = (0, 30))
  w3D = wireframe!(ax3D, x, y, DAMM_Matrix, overdraw = true,
	transparency = true, color = (:black, 0.1));
  point = @lift(DAMM(hcat($Ts, $θ), $params))
  point3D = @lift(Vec3f.($Ts, $θ, $point))
  scatter3D = scatter!(ax3D, point3D, markersize = 8000, color = :black)
  cb = Colorbar(fig[1, 3], colormap = Reverse(:Spectral), limits = (0, 30),
	   label = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"));

  ax2D = Axis(fig[2, 1])
  isoθ = @lift(collect(range($θ, length=length(x), stop=$θ)))
  isoy = @lift(DAMM(hcat(x, $isoθ), $params))
  lines!(ax2D, x, isoy, color = isoy, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  pointTs2D = @lift(Point2f.($Ts, $point))
  scatter!(ax2D, pointTs2D, color = :black, markersize = 20)
  linep = @lift(repeat($point, r))
  linev = @lift(repeat([$θ], r))
  lineh = @lift(repeat([$Ts], r))
  allθ = collect(range(0, length=r, stop=1.0))
  allR = collect(range(0, length=r, stop=30.0))
  lines!(ax2D, x, linep, color = (:black, 0.4), linestyle = :dash)
  lines!(ax2D, lineh, x, color = (:black, 0.4), linestyle = :dash)

  ax2D2 = Axis(fig[2, 2:3])
  isoT = @lift(collect(range($Ts, length=length(x), stop=$Ts)))
  isox = @lift(DAMM(hcat($isoT, $y), $params))
  lines!(ax2D2, y, isox, color = isox, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  pointθ2D = @lift(Point2f.($θ, $point))
  scatter!(ax2D2, pointθ2D, color = :black, markersize = 20)
  lines!(ax2D2, allθ, linep, color = (:black, 0.4), linestyle = :dash)
  lines!(ax2D2, linev, x, color = (:black, 0.4), linestyle = :dash)

  # isoline in the 3D figure
  lines!(ax3D, x, isoθ, isoy, color = isoy, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  # lines!(ax3D, x .+1, isoθ, isoy, linewidth = 1, color = :black)
  # lines!(ax3D, x .-1, isoθ, isoy, linewidth = 1, color = :black)
  lines!(ax3D, isoT, y, isox, color = isox, linewidth = 8,
	 colormap = Reverse(:Spectral), colorrange = (0, 30))
  iso40 = repeat([40], r)
  iso1 = repeat([1], r)
  iso0 = repeat([0], r)
  lines!(ax3D, x, iso1, linep,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, iso40, allθ, linep,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, x, isoθ, iso0,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, iso40, isoθ, allR,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, isoT, allθ, iso0,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, isoT, iso1, allR,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, x, isoθ, linep,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, isoT, allθ, linep,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)
  lines!(ax3D, isoT, isoθ, allR,
	 color = (:black, 0.4), linestyle = :dash, transparency = true)

  lines!(ax3D, x, iso1, isoy, color = isoy, linewidth = 8, alpha = 0.2,
	 colormap = Reverse(:Spectral), colorrange = (0, 30), transparency = true)
  lines!(ax3D, iso40, y, isox, color = isox, linewidth = 8, alpha = 0.2,
	 colormap = Reverse(:Spectral), colorrange = (0, 30), transparency = true)

  point3D_T = @lift(Vec3f.($Ts, 1.0, $point))
  point3D_θ = @lift(Vec3f.(40.0, $θ, $point))
  scatter3D_T = scatter!(ax3D, point3D_T, markersize = 8000, color = :black)
  scatter3D_θ = scatter!(ax3D, point3D_θ, markersize = 8000, color = :black)

  ylims!(ax2D, 0.0, 30.0); xlims!(ax2D, 10.0, 40.0);
  ylims!(ax2D2, 0.0, 30.0); xlims!(ax2D2, 0.0, 1.0);
  xlims!(ax3D, 0.0, 40.0);
  ylims!(ax3D, 0.0, 1.0);
  zlims!(ax3D, 0.0, 30.0);

  ax3D.xlabel = to_latex("T_{soil} (°C)");
  ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
  ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  ax3D.zlabeloffset = 80
  ax3D.xlabeloffset = 50
  ax3D.ylabeloffset = 60

  ax2D.xlabel = to_latex("T_{soil} (°C)");
  ax2D.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  # ax2D2.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
  hideydecorations!(ax2D2, ticks = false)
  ax2D2.xlabel = to_latex("\\theta (m^3 m^{-3})");

  #FZ = 30; ax2D.xlabelsize = FZ; ax2D.ylabelsize = FZ; ax2D2.xlabelsize = FZ; ax2D2.ylabelsize = FZ;
  #ax2D.xticklabelsize = FZ; ax2D.yticklabelsize = FZ; ax2D2.xticklabelsize = FZ; ax2D2.yticklabelsize = FZ;
  colsize!(fig.layout, 1, Relative(1/2))
  #colsize!(fig.layout, 1, Aspect(1, 2.0))
  rowsize!(fig.layout, 1, Relative(1/2))
  #resize_to_layout!(fig)

  supertitle = Label(fig[0, :], "Dual Arrhenius and Michaelis-Menten (DAMM) interactive visualisation, v0.1.3", textsize = fontsize*4/3)

  cb.alignmode = Mixed(right = 0)
  #set_theme!(figure_padding = 30)
  DataInspector(fig)
  fig
  return fig
end
