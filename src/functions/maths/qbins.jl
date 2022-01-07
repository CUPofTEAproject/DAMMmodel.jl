"""
    qbins(x, y, z, n)

Bins x into n quantiles, each xbin into n quantiles of y, return z quantile

# Examples
```julia-repl
julia> df = DataFrame(x=1:20, y=6:25, z=11:30)
julia> xmed, ymed, zmed = qbins(df.T, df.M, df.R, 3)
  xmed = [9, 9, 9, 15, 15, 15, 21, 21, 21]
  ymed = [12, 14, 16, 19, 20.5, 22, 25, 27, 29]
  zmed = [2, 4, 6, 8.5, 10.5, 15, 17, 19]
```
"""
function qbins(x, y, z, n)
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
