# Least square error fit of the DAMM model to data
using LsqFit, CSV

# Load fixed param
#EaSx = 53 
R = 8.314472*10^-3 # Universal gas constant
Dl = 3.17 # Diffusion coeff of substrate in liquid phase
Sxt = 0.0125 # Soil C content
p = 2.4*10^-2 # Fraction of soil C that is considered soluble
Dgas = 1.67 # Diffusion coefficient of oxygen in air
# Db = 1.53 # Soil bulk density !! DAMM complex if SWC > 0.365. old 1.5396
Db = 1.43
Dp = 2.52 # Soil particle density

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

