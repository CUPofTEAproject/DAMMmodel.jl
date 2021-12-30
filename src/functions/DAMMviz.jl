include(joinpath("functions", "DAMM_scaled_porosity.jl"));
L = 40 # resolution
x = collect(range(1, length=L, stop=1))
[append!(x, collect(range(i, length=L, stop=i))) for i = 2:40]
x = reduce(vcat,x)
y = collect(range(0.0, length=L, stop=0.70))
y = repeat(y, outer=L)
x_range = hcat(x, y)
x = Int.(x_range[:, 1])
y_ax = collect(range(0.0, length=L, stop=0.70))
y = collect(range(1, length=L, stop=L))
y = repeat(y, outer=L)
y = Int.(y)
x_ax = collect(range(1, length=L, stop=L))

function create_plot(sliders1, sliders2, sliders3, sliders4, sliders5, sliders6)
	fig = Figure(resolution = (1800, 1000))
	ax3D = LScene(fig[1:2,1]) # should be Axis3 instead of LScene, but bug
	surface!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false) 

	wireframe!(ax3D, x_ax, y_ax, lift((AlphaSx, kMSx, kMO2, Porosity)->
		Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, kMSx, kMO2, Porosity]))),
		sliders1.value, sliders2.value, sliders3.value, sliders4.value),
		   overdraw = true, transparency = true, color = (:black, 0.1));


	# remove these 3 lines when back to Axis3
	scene3D = ax3D.scene
	scale!(scene3D, 3, 150, 7) 
	center!(scene3D)


	#ax3D.xlabel = to_latex("T_{soil} (°C)");
	#ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
	#ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	#zlims!(0, 25)
	#ylims!(0, 0.7)
	#scale!(ax3D, 1, 40, 1) 
	#center!(ax3D)

	#p = [1,20,50,0.7]
	
	ax2D = Axis(fig[1,2])
	ts1 = collect(10:1:35)
	lines!(ax2D, ts1, lift((AlphaSx, kMSx, kMO2, Porosity, sm) -> DAMM(
	 hcat(ts1, collect(range(sm, length=length(ts1), stop=sm))), [AlphaSx, kMSx, kMO2, Porosity]),
	 sliders1.value, sliders2.value, sliders3.value, sliders4.value, sliders5.value), color = :blue, linewidth = 8)
	
	ax2D2 = Axis(fig[2,2])
	sm2 = collect(0.0:0.02:0.7)	
	lines!(ax2D2, sm2, lift((AlphaSx, kMSx, kMO2, Porosity, ts) -> DAMM(
	 hcat(collect(range(ts, length=length(sm2), stop=ts)), sm2), [AlphaSx, kMSx, kMO2, Porosity]),
	 sliders1.value, sliders2.value, sliders3.value, sliders4.value, sliders6.value), color = :red, linewidth = 8)

	# isoline in the 3D figure
	lines!(ax3D, lift((AlphaSx, kMSx, kMO2, Porosity, sm) ->
	Point3f0.(ts1, collect(range(sm, length=length(ts1), stop=sm)), DAMM(
	hcat(ts1, collect(range(sm, length=length(ts1), stop=sm))), [AlphaSx, kMSx, kMO2, Porosity])),
	sliders1.value, sliders2.value, sliders3.value, sliders4.value, sliders5.value), color = :blue, linewidth = 8)

	lines!(ax3D, lift((AlphaSx, kMSx, kMO2, Porosity, ts) ->
	Point3f0.(collect(range(ts, length=length(sm2), stop=ts)), sm2, DAMM(
	hcat(collect(range(ts, length=length(sm2), stop=ts)), sm2), [AlphaSx, kMSx, kMO2, Porosity])),
	sliders1.value, sliders2.value, sliders3.value, sliders4.value, sliders6.value), color = :red, linewidth = 8)

	
	ylims!(ax2D, 0.0, 30.0); xlims!(ax2D, 10.0, 35.0);
	ylims!(ax2D2, 0.0, 30.0); xlims!(ax2D2, 0.0, 0.8);
	ax2D.xlabel = to_latex("T_{soil} (°C)");
	ax2D.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	ax2D2.ylabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");
	ax2D2.xlabel = to_latex("\\theta (m^3 m^{-3})");
	
	FZ = 30; ax2D.xlabelsize = FZ; ax2D.ylabelsize = FZ; ax2D2.xlabelsize = FZ; ax2D2.ylabelsize = FZ;
	ax2D.xticklabelsize = FZ; ax2D.yticklabelsize = FZ; ax2D2.xticklabelsize = FZ; ax2D2.yticklabelsize = FZ;

	return fig
end

sr =   [0.5:0.1:1, # alpha
	0.0001:0.5:30, # kMsx
	0.0001:3:100, # kmo2
	0.5:0.05:0.7, # porosity
	0.4:0.02:0.7, # soil moisture
	30:1:35]; # soil temperature

app = App() do session::Session    
	sliders1 = JSServe.Slider(sr[1])
	sliders2 = JSServe.Slider(sr[2])
	sliders3 = JSServe.Slider(sr[3])
	sliders4 = JSServe.Slider(sr[4])
	sliders5 = JSServe.Slider(sr[5])
	sliders6 = JSServe.Slider(sr[6])
	fig = create_plot(sliders1, sliders2, sliders3, sliders4, sliders5, sliders6)    
    	slider1 = DOM.div("Temperature sensitivity, alpha: ", sliders1, sliders1.value)
	slider2 = DOM.div("Moisture limitation, kMsx: ", sliders2, sliders2.value)
	slider3 = DOM.div("Oxygen limitation, kMO2: ", sliders3, sliders3.value)
	slider4 = DOM.div("Porosity: ", sliders4, sliders4.value)
	slider5 = DOM.div("isoline: fixed soil moisture (%): ", sliders5, sliders5.value)
	slider6 = DOM.div("isoline: fixed soil temperature (C): ", sliders6, sliders6.value)
    	return JSServe.record_states(session, DOM.div(slider1, slider2, slider3, slider4, slider5, slider6, fig))
end

