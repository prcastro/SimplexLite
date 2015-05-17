include("../julia/SimplexPhase2.jl")
using SimplexPhase2

A = [1.0 0.0 1.0];
b = [3.0];
c = [0.0; -1.0; 0.0];
x = [0.0; 0.0; 3.0];

simplex!(A,x,b,c);
