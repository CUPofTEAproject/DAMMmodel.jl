function DAMM_Makie()
	L = 40
	
	# to improve later, use: 
	# y=repeat(collect(1:10), outer=[10])
	# x=repeat(collect(1:10), inner=[10])
	
	x = collect(range(1, length=L, stop=1))
	[append!(x, collect(range(i, length=L, stop=i))) for i = 2:40]
	x = reduce(vcat,x)
	y = collect(range(0.01, length=L, stop=0.40))
	y = repeat(y, outer=L)
	x_range = hcat(x, y)

	x = Int.(x_range[:, 1])
	y_ax = collect(range(0.01, length=L, stop=0.40))
	y = collect(range(1, length=L, stop=L))
	y = repeat(y, outer=L)
	y = Int.(y)
	x_ax = collect(range(1, length=L, stop=L))
	
	scene, layout = layoutscene(resolution = (2500, 1500));
	texts = Array{LText}(undef,5);
	sliderranges = [
	    3.46e-8:1e-8:1e-6, 
	    1e8:1e6:5e8,
	    0.002:1e-5:0.01,
	    62.0:0.2:70.0,
	    0.0125:0.001:0.02];
	sliders = [LSlider(scene, range = sr) for sr in sliderranges];
	texts[1] = LText(scene, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[1].value), textsize=35, width = Auto(false));
	texts[2] = LText(scene, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[2].value), textsize=35, width = Auto(false));
	texts[3] = LText(scene, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[3].value), textsize=35, width = Auto(false));
	texts[4] = LText(scene, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[4].value), textsize=35, width = Auto(false));
	texts[5] = LText(scene, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[5].value), textsize=35, width = Auto(false));
	vertical_sublayout = layout[1, 1] = vgrid!(
	    Iterators.flatten(zip(texts, sliders))...;
	    width = 200, height = 1500); #Auto(false));

	#ax3D = layout[1, 2] = LRect(scene, visible = false);
	#scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);

	scene3D = layout[1, 2] = LScene(scene, scenekw = (camera = cam3d!, raw = false, show_axis = true));

	surface!(scene3D, x_ax, y_ax, lift((kMSx, AlphaSx, kMO2, EaSx, Sxtot)->Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, EaSx, kMSx, kMO2, 0.4, Sxtot]))), sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), colormap = :BuGn, transparency = true, alpha = 0.2, shading = false, limits = Rect(10, 0, 0, 25, 0.4, 20));

	wireframe!(scene3D, x_ax, y_ax, lift((kMSx, AlphaSx, kMO2, EaSx, Sxtot)->Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, EaSx, kMSx, kMO2, 0.4, Sxtot]))), sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), overdraw = true, transparency = true, color = (:black, 0.05));

	scale!(scene3D.scene, 1.3, 75, 1.8);
	center!(scene3D.scene);
	axis3D = scene3D.scene[Axis]
	axis3D[:ticks][:textsize] = (600.0,600.0,600.0);
	axis3D.names.axisnames = ("", "", "");
	axis3D.names.axisnames = (to_latex("T_{soil} (°C)"), to_latex("\\theta (m^3 m^{-3})"), to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"));
	axis3D[:names][:textsize] = (600.0,600.0,600.0); # same as axis.names.textsize
scene
end
