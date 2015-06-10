function simplexPhase1(A::Array{Float64, 2}, b::Array{Float64, 1},
                        m::Int, n::Int)

    # Auxiliary problem:
    # MIN. sum(y_i)
    # S.T. Ax + y = b
    #      x, y >= 0

    println("SIMPLEX: Phase 1")
    println("========================================")

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
    Binv = A[:, bind]^(-1)

    # Find optimal BFS of the auxiliary problem using Simplex Algorithm
    ind, d = simplex!(A, Binv, m, n, c, bind, nbind, v)

    # Here ind = 0, since the auxiliary problem is feasible

    # if y != 0 the original problem is not feasible
    if v[(n-m+1):n] != zeros(m)
        ind = 1
        println("The original problem isn't feasible")
    end

    return ind, v[1:(n-m)]
end

function simplexPhase2!(A::Array{Float64, 2}, x::Array{Float64, 1}, b::Array{Float64, 1},
                        c::Array{Float64, 1}, m::Int, n::Int)

    println("\nSIMPLEX: Phase 2")
    println("========================================\n")

    # Find non-basic indexes
    nbind  = find(x .== 0.0)
    # Drop last indexes if we have more than n-m non-basic indexes
    length(nbind) > (n-m) && (nbind = nbind[1:n-m])
    # Find basic indexes
    bind = filter(i -> !(i in nbind), eachindex(x))

    # Compute the inverse of the basic matrix
    Binv = inv(A[:, bind])

    # Find optimal BFS using Simplex Algorithm
    ind, d = simplex!(A, Binv, m, n, c, bind, nbind, x)

    # Print corresponding solution/direction
    println("\n========================================")
    if ind == 0
        println("Optimal BFS found with cost: ", c⋅x)
        print_vec(1:n, x)
    else
        println("Direction associated with cost -Inf:")
        print_vec(1:n, d)
    end

    # Sanity check
    @assert A*x == b "Solution isn't feasible?!"

    return ind, d
end

function simplexStep!(A::Array{Float64, 2},
                      Binv::Array{Float64, 2},
                      n::Int,
                      c::Array{Float64, 1},
                      bind::Array{Int, 1},
                      nbind::Array{Int, 1},
                      x::Array{Float64, 1})

    # Compute the reduced costs
    redc, j = reducedCosts(A, Binv, c, bind, nbind)

    # When j = 0, reduced costs are all non-negative
    # and we found an optimal solution
    j == 0 && return 0, zeros(n)

    # Find j-th basic direction
    d       = zeros(n)
    d[bind] = -Binv*A[:,j]
    d[j]    = 1.0

    # If non-negative, this direction leads to cost = -Inf
    if all(d .>= 0)
        # We return x as the direction that leads to cost = -Inf
        x[:] = d[:]
        return -1, d
    end

    # Index j is the one that enters the base
    println("\nEnters the basis: ", j)

    # Print the direction
    println("\nDirection:")
    print_bind(bind, d)

    # Compute Θ*
    Θ, idx = theta(x[bind], d[bind])
    println("\nΘ*: ", Θ)

    # Convert bind index to R^n index
    # This index exits the base
    i = bind[idx]
    println("\nLeaves the basis: ", i)

    # Compute new vector
    x[:] += Θ*d

    # Update basic, non-basic indexes and the inverse of the basic matrix
    updateBinv!(Binv, -d[bind], idx)
    bind[find(bind .== i)]   = j
    nbind[find(nbind .== j)] = i

    println("\n----------------------------------------")

    return 1, d
end
