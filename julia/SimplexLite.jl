module SimplexLite

export simplex, simplex!

include("simplex.jl")
include("utils.jl")

@doc """
*simplex(A::Array{Float64, 2}, b::Array{Float64, 1}, c::Array{Float64, 1})*

Solves the problem:

MINIMIZE     cx
SUBJECT TO   Ax = b
              x >= 0

using the Simplex Algorithm, given only the restrictions and the cost-vector

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `b`: Restriction vector [Float64 Vector m]
* `c`: Cost vector [Float64 Vector n]

### Returns
* `ind`: 1 if unfeasible, 0 if optimal solution was found, -1 if cost is -Inf [Int]
* `x`: Optimal solution (if one was found) or the last basic feasible solution (if cost is -Inf) [Float64 Vector n]
* `d`: Last direction (if optimal solution is found) or the direction leading to cost -Inf [Float64 Vector n]
""" ->
function simplex(A::Array{Float64, 2}, b::Array{Float64, 1}, c::Array{Float64, 1})
    m, n   = size(A)
    ind, x = simplexPhase1(A, b, m, n)

    # Unfeasible problem
    ind == 1 && return ind, x, zeros(n)

    ind, d = simplexPhase2!(A, x, b, c, m, n)
    return ind, x, d
end

@doc """
*simplex(A::Array{Float64, 2}, x::Array{Float64, 1}, b::Array{Float64, 1}, c::Array{Float64, 1})*

Solves the problem:

MINIMIZE     cx
SUBJECT TO   Ax = b
              x >= 0

using the Simplex Algorithm, given the restrictions, the cost-vector and a initial basic feasible solution.

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `x`: Initial Basic Feasible Solution [Float64 Vector m] **modified by the function**
* `b`: Restriction vector [Float64 Vector m]
* `c`: Cost vector [Float64 Vector n]

### Returns
* `ind`: 0 if optimal solution was found, -1 if cost is -Inf [Int]
* `d`: Last direction (if optimal solution is found) or the direction leading to cost -Inf [Float64 Vector n]
""" ->
function simplex!(A::Array{Float64, 2}, x::Array{Float64, 1},
                  b::Array{Float64, 1}, c::Array{Float64, 1})
    m, n = size(A)
    return simplexPhase2!(A, x, b, c, m, n)
end

@doc """
*simplex!(A::Array{Float64, 2},
          Binv::Array{Float64, 2},
          m::Int, n::Int,
          c::Array{Float64, 1},
          bind::Array{Int, 1},
          nbind::Array{Int, 1},
          v::Array{Float64, 1})*

Solves the problem:

MINIMIZE     cx
SUBJECT TO   Ax = b
            x >= 0

using the Simplex Algorithm, ore implementation of Simplex Algorithm given a BFS, the inverse of the basic matrix, the restrictions, the cost-vector, the dimensions
and the basic indexes. This function won't print anything on screen nor check its inputs.

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `Binv`: Inverse of the basic matrix [Float64 Array m × n] **modified by the function**
* `m`: Number of restrictions [Int]
* `n`: Number of variables (dimensionality of x) [Int]
* `c`: Cost vector [Float64 Vector n]
* `bind`: Basic indexes [Int Array m]
* `nbind`: Non-basic indexes [Int Array (n-m)]
* `x`: Initial Basic Feasible Solution [Float64 Vector n] **modified by the function**

### Returns
* `ind`: 0 if optimal solution was found, -1 if cost is -Inf [Int]
* `d`: Last direction (if optimal solution is found) or the direction leading to cost -Inf [Float64 Vector n]
""" ->
function simplex!(A::Array{Float64, 2}, Binv::Array{Float64, 2},
                  m::Int, n::Int, c::Array{Float64, 1},
                  bind::Array{Int, 1}, nbind::Array{Int, 1},
                  x::Array{Float64, 1})

    d   = Array(Float64, n)
    ind = 1
    while ind == 1
        # Simplex iteration
        ind, d = simplexStep!(A, Binv, n, c, bind, nbind, x)
    end

    return ind, d
end

end # SimplexLite
