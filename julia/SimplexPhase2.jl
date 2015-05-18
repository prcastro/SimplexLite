module SimplexPhase2

export simplex!

function simplex!(A::Array{Float64, 2},
                  x::Array{Float64, 1},
                  b::Array{Float64, 1},
                  c::Array{Float64, 1})
    println("\nSIMPLEX: Fase 2")
    println("========================================\n")

    # Get A size
    m, n = size(A)

    # Find basic and non-basic indexes
    bind  = find(x .!= 0.0)
    nbind = find(x .== 0.0)

    ind         = 1
    simplexstep = 0
    while ind  == 1
        # Print iteration, basic variables and cost function
        println("Iterando ", simplexstep)
        println("----------------------------------------")
        print_bind(bind, x)
        println("\nValor Função Objetivo: ", dot(c, x))

        # Simplex iteration
        ind = naiveStep!(A, c, bind, nbind, x)

        # Next step
        simplexstep += 1
    end

    println("\n========================================")

    # Print corresponding solution/direction
    if ind == 0
        println("\nSolução ótima encontrada com custo ", dot(c, x))
    else
        println("\nDireção associada ao custo -Inf")
    end

    print_vec(1:n, x)
end

function naiveStep!(A::Array{Float64, 2},
                    c::Array{Float64, 1},
                    bind::Array{Int, 1},
                    nbind::Array{Int, 1},
                    x::Array{Float64, 1})

    # Compute B's LU decomposition
    lub = lufact(A[:, bind])
    L, U = lub[:L], lub[:U]

    # Compute the reduced costs
    redc, idx = reducedCost(A, c, bind, nbind, L, U)
    println("Custos Reduzidos")
    print_vec(nbind, redc)

    # When idx = 0, reduced costs are all non-negative
    # and we found an optimal solution
    idx == 0 && return 0

    # Convert nbind index to R^n index
    j = nbind[idx]

    # Find j-th basic direction
    d       = zeros(size(A, 2))
    d[bind] = -(U \ (L \ A[:, j]))
    d[j]    = 1.0

    # If non-negative, this direction leads to cost = -Inf
    if all(d .>= 0)
        # We return x as the direction that leads to cost = -Inf
        x[:] = d[:]
        return -1
    end

    # Index j is the one that enters the base
    println("\nEntra na base:", j)

    # Print the direction
    println("\nDireção:")
    print_bind(bind, d)

    # Compute Θ*
    theta, idx = thetaStep(x[bind], d[bind])
    println("\nΘ*: ", theta)

    # Convert bind index to R^n index
    # This index exits the base
    i = bind[idx]
    println("\nSai da base:", i)

    # Compute new vector
    x[:] += theta*d

    # Update basic and non-basic indexes
    bind[find(bind .== i)]   = j
    nbind[find(nbind .== j)] = i
    println("\n----------------------------------------")

    return 1
end

function reducedCost(A::Array{Float64, 2},
                     c::Array{Float64, 1},
                     bind::Array{Int, 1},
                     nbind::Array{Int, 1},
                     L::Array{Float64, 2},
                     U::Array{Float64, 2})

    # Calculate the reduced costs in a vectorized way
    redc = vec(c[nbind]' - (L' \ (U' \ c[bind]))'*A[:, nbind])

    # Find the negative costs, if any
    negs = find(redc .< 0)

    # If no negative costs are found, return ind = 0,
    # else, return the first negative cost
    return redc, (length(negs) == 0 ? 0 : negs[1])
end

function thetaStep(xB::Array{Float64,1},
                   dB::Array{Float64,1})

    # Computes the largest step we can do
    # without leaving the polyhedra
    theta = Inf
    imin = 0
    for i in 1:length(xB)
         @inbounds if dB[i] < 0
            aux = - xB[i] / dB[i]
            if aux < theta
                theta = aux
                imin = i
            end
        end
    end

    return theta, imin
end

function print_vec(indexes, v::Array{Float64, 1})
    # Print a vector and correspondent indexes
    for i=1:length(v)
        @inbounds println(indexes[i], " ", v[i])
    end
end

function print_bind(bind::Array{Int, 1}, x::Array{Float64, 1})
    # Print "basic elements" of a vector
    for i = 1:length(bind)
        @inbounds println(bind[i], " ", x[bind[i]])
    end
end

end
