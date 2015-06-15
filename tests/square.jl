include("../julia/SimplexLite.jl")
using SimplexLite

A = [1.0 0.0 1.0 0.0; 0.0 1.0 0.0 1.0]
b = [3.0; 2.0]
c = [-1.0; -1.0; 0.0; 0.0]

simplex(A,b,c)
