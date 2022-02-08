# Animate DAMM in the REPL
# Not included in DAMMmodel module for now

using DAMMmodel
using Plots; unicodeplots()
df = DAMMfdata(50)
d = DAMMmat(df.Tₛ, df.θ, df.Rₛ, 50)
surface(d.x, d.y.*100, d.DAMM_Matrix, colormap = :jet, border = :dotted)

