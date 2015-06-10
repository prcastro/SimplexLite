# SimplexLite
Implementation of the Simplex Algorithm for MAC315 class

## Running Modules
On Julia:

```julia
include("julia/SimplexLite.jl")
using SimplexLite

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
