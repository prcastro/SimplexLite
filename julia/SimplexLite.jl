module SimplexLite

export simplex, simplex!

include("simplex.jl")
include("utils.jl")

# Simplex Algorithm given only the restrictions and the cost-vector
function simplex(A::Array{Float64, 2}, b::Array{Float64, 1}, c::Array{Float64, 1})
    m, n   = size(A)
    ind, x = simplexPhase1(A, b, m, n)

    # Unfeasible problem
    ind == 1 && return ind, x, zeros(n)

    # Sanity check
    @assert A*x == b "Solution isn't feasible"

    ind, d = simplexPhase2!(A, x, b, c, m, n)
    return ind, x, d
end

# Simplex Algorithm given a BFS
function simplex!(A::Array{Float64, 2}, x::Array{Float64, 1},
                  b::Array{Float64, 1}, c::Array{Float64, 1})
    m, n = size(A)

    # Input check (aka "dumb user check")
    @assert A*x == b "Solution isn't feasible"

    return simplexPhase2!(A, x, b, c, m, n)
end

# Core implementation of Simplex Algorithm
# given a BFS, the inverse of the basic matrix,
# the restrictions, the cost-vector, the dimensions
# and the basic indexes
function simplex!(A::Array{Float64, 2}, Binv::Array{Float64, 2},
                  m::Int, n::Int, c::Array{Float64, 1},
                  bind::Array{Int, 1}, nbind::Array{Int, 1},
                  v::Array{Float64, 1})
    ind         = 1
    simplexstep = 0
    d = Array(Float64, n)
    while ind == 1
        # Print iteration, basic variables and cost function
        println("Iteration ", simplexstep)
        println("----------------------------------------")
        println("Basic Feasible Solution (Basic Indexes):")
        print_bind(bind, v)
        println("\nValue of cost function: ", c⋅v)

        # Simplex iteration
        ind, d = simplexStep!(A, Binv, n, c, bind, nbind, v)

        # Next step
        simplexstep += 1
    end

    return ind, d
end

end # SimplexLite
