# Least square error fit of the DAMM model to data

	# To do: put all this into a function (avoid global stuff)
Param_ini = [1.0, 62.0, 3.46, 2.0] # Scaled Param, as explained above. AlphaSx, EaSx, kMsx, kMo2
# df = CSV.read("Input\\RSMmean.csv",dateformat="yyyy-mm-dd")
# SWC = df.SWC; Tsoil = df.Tsoil; Rsoil = Dep_var = df.RSM
# Ind_var = hcat(Tsoil, SWC)
	# Fit DAMM to data
# fit = curve_fit(DAMM, Ind_var, Dep_var, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
# Param_fit = coef(fit)
# Modeled_data = multimodel(Ind_var,Param_fit)

