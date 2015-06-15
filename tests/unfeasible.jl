include("../julia/SimplexLite.jl")
using SimplexLite

A = [1. 1 -1 0 0;
     -2 1 0 -1 0;
     0 3 0 0 1]
b = [7.; 3; 1]
c = [1.; 1; 1; 0; 0]

ind, v, d = simplex(A, b, c)
println("ind = ", ind)
println("v = ", v)
println("d = ", d)
