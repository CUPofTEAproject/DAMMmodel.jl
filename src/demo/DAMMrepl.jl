# Animate DAMM in the REPL
# Not included in DAMMmodel module for now

using DAMMmodel
using Plots; unicodeplots()
df = DAMMfdata(50)
d = DAMMmat(df.Tₛ, df.θ, df.Rₛ, 50)

main() = begin
  anim = @animate for i = -180:10:180
    surface(d.x, d.y.*100, d.DAMM_Matrix, colormap = :jet, camera = (i, 30))
  end
  #gif(anim, "anim_fps5.gif", fps=5)
end

main()

