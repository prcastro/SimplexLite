@doc """
*simplexPhase1(A::Matrix{Float64}, b::Vector{Float64}, m::Int, n::Int)*

Solves the auxiliary problem:

MINIMIZE    sum(y_i)
SUBJECT TO  Ax + y  = b
              x, y >= 0

To find the initial Basic Feasible Solution. If the cost of the auxiliary problem
is -Inf, the original problem is unfeasible. This is called Phase 1 of Simplex Algorithm.

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `b`: Restriction vector [Float64 Vector m]
* `m`: Number of restrictions [Int]
* `n`: Number of variables (dimensionality of x) [Int]

### Returns
* `ind`: Indicates 0 if found initial BFS and 1 if the original problem is unfeasible [Int]
* `x`: Solution found (if ind = 0, this is the initial BFS to the original problem) [Float64 Vector n]
""" ->
function simplexPhase1(A::Matrix{Float64}, b::Vector{Float64},
                        m::Int, n::Int)

    # Initial BFS, x = 0, y = b
    v = vcat(zeros(n), b)

    # Redefine the parameters to match the auxiliary problem
    A = hcat(A, eye(m))
    c = vcat(zeros(n), ones(m))
    n += m

    # Find basic and non-basic indexes
    nbind = collect(1:(n-m))
    bind  = collect((n-m+1):n)

    # Compute the inverse of the first basic matrix
    Binv = inv(A[:, bind])

    # Find optimal BFS of the auxiliary problem using Simplex Algorithm
    ind, d = simplex!(A, Binv, n, c, bind, nbind, v)

    # Here ind = 0, since the auxiliary problem is feasible

    # if y != 0 the original problem is not feasible
    v[(n-m+1):n] != zeros(m) && (ind = 1)

    return ind, v[1:(n-m)]
end

@doc """
*simplexPhase2!(A::Matrix{Float64}, x::Vector{Float64}, b::Vector{Float64}, m::Int, n::Int)*

Solves the problem:

MINIMIZE     cx
SUBJECT TO   Ax = b
              x >= 0

given an initial Basic Feasible Solution and all other parameters (including dimensionality).

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `x`: Initial Basic Feasible Solution [Float64 Vector n] **modified by the function**
* `c`: Cost vector [Float64 Vector n]
* `m`: Number of restrictions [Int]
* `n`: Number of variables (dimensionality of x) [Int]

### Returns
* `ind`: Indicates 0 if found initial BFS and 1 if the original problem is unfeasible [Int]
* `d`: Last direction (if optimal solution is found) or the direction leading to cost -Inf [Float64 Vector n]
""" ->
function simplexPhase2!(A::Matrix{Float64}, x::Vector{Float64},
                        c::Vector{Float64}, m::Int, n::Int)

    # Find non-basic indexes
    nbind  = findin(x, 0.0)

    # Drop last indexes if we have more than (n-m) non-basic indexes
    length(nbind) > n-m && (nbind = nbind[1:n-m])

    # Find basic indexes
    bind = Int[]
    for i = eachindex(x)
        if !(i in nbind)
            push!(bind, i)
        end
    end

    # Compute the inverse of the basic matrix
    Binv = inv(A[:, bind])

    # Find optimal BFS using Simplex Algorithm
    ind, d = simplex!(A, Binv, n, c, bind, nbind, x)

    return ind, d
end

@doc """
*simplexStep!(A::Matrix{Float64},
             Binv::Matrix{Float64},
             n::Int,
             c::Vector{Float64},
             bind::Vector{Int},
             nbind::Vector{Int},
             x::Vector{Float64})*

A single step of the simplex algorithm. Goes from a BFS to another BFS while minimizing the cost.
Indicates if the BFS is already optimal.

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `Binv`: Inverse of the basic matrix [Float64 Array m × n] **modified by the function**
* `n`: Number of variables (dimensionality of x) [Int]
* `c`: Cost vector [Float64 Vector n]
* `bind`: Basic Indexes [Int Vector m] **modified by the function**
* `nbind`: Non-Basic Indexes [Int Vector (n-m)] **modified by the function**
* `x`: Initial Basic Feasible Solution [Float64 Vector n] **modified by the function**

### Returns
* `ind`:  1 if not finished (the BFS found isn't optimal), 0 if optimal solution was found, -1 if cost is -Inf [Int]
* `d`: Last direction (if optimal solution is found) or the direction leading to cost -Inf [Float64 Vector n]
""" ->
function simplexStep!(A::Matrix{Float64},
                      Binv::Matrix{Float64},
                      n::Int,
                      c::Vector{Float64},
                      bind::Vector{Int},
                      nbind::Vector{Int},
                      x::Vector{Float64})

    # Compute the reduced costs
    redc, nidx, j = reducedCosts(A, Binv, c, bind, nbind)

    # When j = 0, reduced costs are all non-negative
    # and we found an optimal solution
    j == 0 && return 0, zeros(n)

    # Find j-th basic direction
    d       = zeros(n)
    d[bind] = -Binv*A[:,j]
    d[j]    = 1.0

    # If non-negative, this direction leads to cost = -Inf
    aux = 0
    for i in eachindex(d)
        if d[i] < 0
            aux = 1
            break
        end
    end
    aux == 0 && return -1, d

    # Index j is the one that enters the base

    # Compute Θ*
    Θ, bidx = theta(x[bind], d[bind])

    # Convert bind index to R^n index
    # This index exits the base
    i = bind[bidx]

    # Compute new vector
    x[:] += Θ*d

    # Update basic, non-basic indexes and the inverse of the basic matrix
    updateBinv!(Binv, -d[bind], bidx)
    bind[bidx]  = j
    nbind[nidx] = i

    return 1, d
end
