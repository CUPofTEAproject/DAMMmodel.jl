# Animate DAMM in the REPL
# Not included in DAMMmodel module for now

using DAMMmodel
using Plots; unicodeplots()
df = DAMMfdata(20)
d = DAMMmat(df.Tₛ, df.θ, df.Rₛ, 20)

main() = begin
  anim = @animate for i = -180:10:180
    surface(d.x, d.y.*100, d.DAMM_Matrix, colormap = :jet, camera = (i, 30))
  end
  #gif(anim, "anim_fps5.gif", fps=5)
end

main()

# other method, similar result
for i = -180:1:180
  println(i)
  surface(d.x, d.y.*100, d.DAMM_Matrix, colormap = :jet, border = :dotted, camera = (i, 30)) |> display
  sleep(0.01)
  print("\e[2J")
end

