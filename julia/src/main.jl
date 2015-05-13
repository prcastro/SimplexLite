function simplex!(A, x, b, c)
    println("SIMPLEX: Fase 2")
    println("\n========================================")

    # Get A size
    m, n = size(A)

    # Find basic and non-basic indexes
    bind  = find(x .!= 0)
    nbind = find(x .== 0)

    ind         = 1
    simplexstep = 0
    while ind == 1
        # Print iteration, basic variables and cost function
        println("\nIterando ", simplexstep)
        println("----------------------------------------")
        print_bind(bind, x)
        println("\nValor Função Objetivo: ", dot(c, x))

        # println("x:")
        # println(x)

        # Simplex iteration
        ind = naiveStep!(A, c, bind, nbind, x)

        # Next step
        simplexstep += 1
        if simplexstep == 5
            return
        end
    end

    # Print corresponding solution/direction
    println("\n========================================")
    if ind == 0
        println("\nSolução ótima encontrada com custo ", dot(c, x))
    else
        println("\nDireção associada ao custo -Inf")
    end

    for i=1:n
        println(i, " ", x[i])
    end
end

function naiveStep!(A, c, bind, nbind, x)
    # Compute B and its LU decomposition
    B    = A[:, bind]
    L, U = lu(B)[1:2]

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
    d[j]    = 1

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
    theta, idx = thetaStep(x[bind], d[bind], length(bind))
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

    println(x)
    return 1
end

function reducedCost(A, c, bind, nbind, L, U)
    # Calculate the reduced costs in a vectorized way
    p = L' \ (U' \ c[bind]) # p = (c(bind)' * inv(A(bind)))'
    redc = c[nbind]' - p'*A[:, nbind]

    # Find the negative costs, if any
    negs = find(redc .< 0)

    # If no negative costs are found, return ind = 0
    if length(negs) == 0
        return redc, 0
    end

    # Return the first negative cost
    return redc, negs[1]
end

function thetaStep(xB, dB, m)
    # Computes the largest step we can do
    # without leaving the polyhedra
    theta = Inf
    imin  = 0
    for i=1:m
        if dB[i] < 0
            aux = - xB[i] / dB[i]
            if aux < theta
                theta = aux
                imin = i
            end
        end
    end

    return theta, imin
end

function print_vec(indexes, v)
    # Print a vector and correspondent indexes
    for i=1:length(v)
        println(indexes[i], " ", v[i])
    end
end

function print_bind(bind, x)
    # Print "basic elements" of a vector
    for i = 1:length(bind)
        println(bind[i], " ", x[bind[i]])
    end
end
