# SimplexLite
Implementation of phase 2 of Simplex Algorithm for the MAC315 class

## Running Modules
On Julia:

```julia
include("julia/SimplexPhase2.jl")
using SimplexPhase2

# Define your model here
simplex!(A,x,b,c)
```


On Octave:
```octave
addpath("octave")

# Define your model here
simplex(A,b,c,m,n)
```


## Running Tests

Just `cd tests` and run

```bash
julia  testname.jl
octave testname
```
