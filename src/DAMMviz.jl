using GLMakie, UnicodeFun, DAMMmodel, SparseArrays

L = 40 # resolution
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


fig = Figure(resolution = (500, 500))
#fig

#ax1 = fig[1, 1] = Axis(fig, title = "Parameters")
#fig

texts = Array{Label}(undef,5);
sliderranges = [
    3.46e-8:1e-8:1e-6, 
    1e8:1e6:5e8,
    0.002:1e-5:0.01,
    62.0:0.2:70.0,
    0.0125:0.001:0.02];
sliders = [Slider(fig, range = sr) for sr in sliderranges];
texts[1] = Label(fig, text= lift(X->string(to_latex("kM_{sx}"), " = ", round(X, sigdigits = 2), to_latex(" (gC cm^{-3})")), sliders[1].value), textsize=15, width = Auto(false));
texts[2] = Label(fig, text= lift(X->string(to_latex("\\alpha_{sx}"), " = ", X, to_latex(" (mgC cm^{-3} h^{-1})")), sliders[2].value), textsize=15, width = Auto(false));
texts[3] = Label(fig, text= lift(X->string(to_latex("kM_{o2}"), " = ", X, to_latex(" (L L^{-1})")), sliders[3].value), textsize=15, width = Auto(false));
texts[4] = Label(fig, text= lift(X->string(to_latex("E_a"), " = ", X, to_latex(" (kJ mol^{-1})")), sliders[4].value), textsize=15, width = Auto(false));
texts[5] = Label(fig, text= lift(X->string(to_latex("S_x"), " = ", X, to_latex(" (gC cm^{-3})")), sliders[5].value), textsize=15, width = Auto(false));
vertical_sublayout = fig[1, 1] = vgrid!(
    Iterators.flatten(zip(texts, sliders))...;
    width = 200, height = 1000);

ax3D = Axis3(fig[1,2])

surface!(ax3D, x_ax, y_ax, lift((kMSx, AlphaSx, kMO2, EaSx, Sxtot)->Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, EaSx, kMSx, kMO2, 0.4, Sxtot]))), sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), colormap = Reverse(:Spectral), transparency = true, alpha = 0.2, shading = false)#, limits = Rect(10, 0, 0, 25, 0.4, 20));

wireframe!(ax3D, x_ax, y_ax, lift((kMSx, AlphaSx, kMO2, EaSx, Sxtot)->Matrix(sparse(x, y, DAMM(x_range, [AlphaSx, EaSx, kMSx, kMO2, 0.4, Sxtot]))), sliders[1].value, sliders[2].value, sliders[3].value, sliders[4].value, sliders[5].value), overdraw = true, transparency = true, color = (:black, 0.1));

ax3D.xlabel = to_latex("T_{soil} (°C)");
ax3D.ylabel = to_latex("\\theta (m^3 m^{-3})");
ax3D.zlabel = to_latex("R_{soil} (\\mumol m^{-2} s^{-1})");


