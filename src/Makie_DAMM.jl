function DAMM_Makie()
	x = Tsoil_range = 10.0:0.5:35.0;
	y = Msoil_range = 0.0:0.001:0.389;

	scene, layout = layoutscene(resolution = (1000, 700));
	texts = Array{LText}(undef,5);
	sliderranges = [
	    1e-8:1e-8:1e-6, 
	    5e7:1e6:5e8,
	    1e-4:1e-5:1e-2,
	    58.0:0.2:70.0,
	    0.005:0.001:0.02];
	sliders = [LSlider(scene, range = sr) for sr in sliderranges];
	texts[1] = LText(scene, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[1].value), textsize=15, width = Auto(false));
	texts[2] = LText(scene, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[2].value), textsize=15, width = Auto(false));
	texts[3] = LText(scene, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[3].value), textsize=15, width = Auto(false));
	texts[4] = LText(scene, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[4].value), textsize=15, width = Auto(false));
	texts[5] = LText(scene, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[5].value), textsize=15, width = Auto(false));
	vertical_sublayout = layout[1, 1] = vgrid!(
	    Iterators.flatten(zip(texts, sliders))...;
	    width = 200, height = Auto(false));

	#ax3D = layout[1, 2] = LRect(scene, visible = false);
	#scene3D = Scene(scene, lift(IRect2D, ax3D.layoutnodes.computedbbox), camera = cam3d!, raw = false, show_axis = true);

	scene3D = layout[1, 2] = LScene(scene, scenekw = (camera = cam3d!, raw = false, show_axis = true));

	surface!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v, Sxtot_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v, Sxtot = Sxtot_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), colormap = :BuGn, transparency = true, alpha = 0.2, shading = false, limits = Rect(10, 0, 0, 25, 0.4, 20));

	wireframe!(scene3D, x, y, lift((kMSx_v, AlphaSx_v, kMO2_v, EaSx_v, Sxtot_v)->Float64[DAMM(Tsoil, Msoil; kMSx = kMSx_v, AlphaSx = AlphaSx_v, kMO2 = kMO2_v, EaSx = EaSx_v, Sxtot = Sxtot_v) for Tsoil in Tsoil_range, Msoil in Msoil_range], sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), overdraw = true, transparency = true, color = (:black, 0.05));
	scale!(scene3D.scene, 1.3, 75, 1.8);
	center!(scene3D.scene);
	axis3D = scene3D.scene[Axis];
	axis3D[:ticks][:textsize] = (600.0,600.0,600.0);
	#axis3D.names.axisnames = ("", "", "");
	axis3D.names.axisnames = (to_latex("T_{soil} (°C)"), to_latex("\\theta (m^3 m^{-3})"), to_latex("R_{soil} (\\mumol m^{-2} s^{-1})"));
	axis3D[:names][:textsize] = (600.0,600.0,600.0); # same as axis.names.textsize
scene
end
