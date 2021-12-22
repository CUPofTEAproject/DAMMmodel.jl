function qbin(x, y, z, n)
  xq = quantile(x, 0:1/n:1)
  xmed = Float64[] # between quantiles x values
  ymed = Float64[] # between quantiles y values
  zmed = Float64[] # z median for each xy bins
  for i = 1:n # loop for each x between-quantile bin
    ybin = y[x .>= xq[i] .&& x .<= xq[i+1]]
    ybinq = quantile(ybin, 0:1/n:1)
    for j = 1:n # loop for each y between-quantile bin
      push!(xmed, (xq[i] + xq[i+1]) / 2)
      push!(ymed, (ybinq[j] + ybinq[j+1]) / 2)
      push!(zmed, median(z[x .>= xq[i] .&& x .<= xq[i+1] .&& y .>= ybinq[j] .&& y .<= ybinq[j+1]]))
    end
  end
  return xmed, ymed, zmed
end

#= test function
df = DataFrame(R=1:20, T=6:25, M=11:30)
xmed, ymed, zmed = qbin(df.T, df.M, df.R, 3)
=#
