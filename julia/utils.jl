@doc """
*reducedCosts(A::Array{Float64, 2},
              Binv::Array{Float64, 2},
              c::Array{Float64, 1},
              bind::Array{Int, 1},
              nbind::Array{Int, 1})*

Compute the reduced costs until find a negative one.

### Arguments
* `A`: Restriction matrix [Float64 Array m × n]
* `Binv`: Inverse of the basic matrix [Float64 Array m × n]
* `c`: Cost vector [Float64 Vector n]
* `bind`: Basic Indexes [Int Vector m]
* `nbind`: Non-Basic Indexes [Int Vector (n-m)]

### Returns
* `redc`: First negative reduced cost (0.0 if none) [Float64]
* `i`: Index of the first negative reduced cost (0 if none) [Int]
""" ->
function reducedCosts(A::Array{Float64, 2},
                      Binv::Array{Float64, 2},
                      c::Array{Float64, 1},
                      bind::Array{Int, 1},
                      nbind::Array{Int, 1})

    # Auxiliar vector
    p = vec(c[bind]'*Binv)

    # Compute reduced costs until find the first negative one
    for i in nbind
      # Compute the reduced cost
      @inbounds redc = c[i] - dot(p, A[:, i])
      # Return if negative
      all(redc .< 0) && return redc, i
    end

    # If no negative costs are found, return ind = 0 and redc = 0
    return 0.0, 0
end

@doc """
*theta(xB::Array{Float64,1}, dB::Array{Float64,1})*

Computes the largest step we can do without leaving the polyhedra.

### Arguments
* `xB`: Basic elements of Basic Feasible Solution [Float64 Vector n]
* `dB`: Basic elements of the chosen basic direction [Float64 Vector n]

### Returns
* `Θ`: Largest step we can do without leaving the polyhedra [Float64]
* `imin`: Index correspondent to Θ (leaves the basis) [Int]
""" ->
function theta(xB::Array{Float64,1}, dB::Array{Float64,1})
    Θ, imin = Inf, 0
    for i in eachindex(xB)
         @inbounds if dB[i] < 0
            aux = - xB[i] / dB[i]
            if aux < Θ
                Θ = aux
                imin = i
            end
        end
    end

    return Θ, imin
end

@doc """
*updateBinv!(Binv::Array{Float64, 2}, u::Array{Float64, 1}, out::Int)*

Update the inverse of the basic matrix based on the basic direction and the index that leaves the basis.

### Arguments
* `Binv`: Inverse of the basic matrix [Float64 Array m × n] **modified by the function**
* `u`: Minus the basic direction (only the m basic elements of d) [Float64 Vector m]
* `out`: Index of the basis that leaves the basis [Int]
""" ->
function updateBinv!(Binv::Array{Float64, 2}, u::Array{Float64, 1}, out::Int)
    for i in eachindex(u)
        if i != out
            @inbounds Binv[i, :] += (-u[i]/u[out]) * Binv[out, :]
        end
    end
    @inbounds Binv[out,:] /= u[out]
end

@doc "Print a vector and correspondent indexes" ->
function print_vec(indexes, v::Array{Float64, 1})
    for i in eachindex(v)
        @inbounds println(indexes[i], " ", v[i])
    end
end

@doc "Print the basic elements of a vector" ->
function print_bind(bind::Array{Int, 1}, x::Array{Float64, 1})
    for i in eachindex(bind)
        @inbounds println(bind[i], " ", x[bind[i]])
    end
end
