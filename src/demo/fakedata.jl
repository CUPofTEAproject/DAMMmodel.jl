# fake data to be used for demo

struct sdemo
  Tₛ::Vector{Float64} 
  θ::Vector{Float64}
  Rₛ::Vector{Float64}
  p::NTuple{7, Float64}
end

demo = Dict(
  :Tₛ => [10.0, 18.0, 27.0, 15.0],
  :θ  => [0.2,  0.2,  0.4,  0.3 ],
  :Rₛ => [1.0,  1.6,  3.8,  2.2 ],
  :p  => (1e9, 64.0, 3.46e-8, 2.0e-3, 0.7, 0.0125, 1.0)
)

const fake = sdemo(demo[:Tₛ], demo[:θ], demo[:Rₛ], demo[:p])
