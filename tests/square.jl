include("../julia/SimplexLite.jl")
using SimplexLite

A = [1.0 0.0 1.0 0.0; 0.0 1.0 0.0 1.0]
b = [3.0; 2.0]
c = [-1.0; -1.0; 0.0; 0.0]

ind, v, d = simplex(A, b, c)
println("ind = ", ind)
println("v = ", v)
println("d = ", d)
