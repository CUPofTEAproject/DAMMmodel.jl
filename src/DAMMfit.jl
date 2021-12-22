function fitDAMM(Ind_var, Resp)
  lb = [0.0, 0.0, 0.0, 0.0] # params can't be negative
  p_ini = [0.3, 6.4, 1.0, 1.0] # initial parameters
  p_fact = (1e9, 1e1, 1e-6, 1e-4, 1, 1) # factor of param, better fit
  DAMMfix = (x,p) -> DAMM(x, p_fact.*(p[1], p[2], p[3], p[4], poro_val, 0.02))
  fit_bounds = curve_fit(DAMMfix, Ind_var, Resp, p_ini, lower=lb)
  p = fit_bounds.param # fitted param result 
  fparam = p_fact[1:4].*p # multiply them by p_fact
  params = [fparam[1], fparam[2], fparam[3], fparam[4], poro_val, 0.02]
  return params
end
