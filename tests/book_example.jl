include("../julia/SimplexLite.jl")
using SimplexLite

A = [2 1 0 1 0 0; 1 2 -2 0 1 0; 0 1 2 0 0 1.]
b = [10,20,5.]
c = [-2, 1, -2, 0,0,0.]
x = [0,0,0,10,20,5.]

simplex(A,b,c)
