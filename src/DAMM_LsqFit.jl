# Least square error fit of the DAMM model to data

# DAMM model, !for the algorithm to work, Param are scaled to be of similar magnitude
@. multimodel(Ind_var, Param) = (1e8*Param[1]*exp(-Param[2]/(R*(273.15+Ind_var[:, 1]))))* 
(((p*Sxt)*Dl*Ind_var[:, 2]^3)/(1e-8*Param[3]+((p*Sxt)*Dl*Ind_var[:, 2]^3)))* 
((Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^(4/3))/ 
 (1e-3*Param[4]+(Dgas*0.209*(1-Db/Dp-Ind_var[:, 2])^(4/3))))* 
10000*10/1000/12*1e6/60/60 

Param = Param_ini = [1.0, 62.0, 3.46, 2.0] # Scaled Param, as explained above. AlphaSx, EaSx, kMsx, kMo2

# df = CSV.read("Input\\RSMmean.csv",dateformat="yyyy-mm-dd")
# SWC = df.SWC; Tsoil = df.Tsoil; Rsoil = Dep_var = df.RSM
# Ind_var = hcat(Tsoil, SWC)

# Fit DAMM to data
# fit = curve_fit(multimodel, Ind_var, Dep_var, Param_ini) # For DAMM, Ind_var is Tsoil and SWC, Dep_var is Rsoil
# Param_fit = coef(fit)
# Modeled_data = multimodel(Ind_var,Param_fit)

