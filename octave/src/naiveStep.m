function [ind vec] = naiveStep(A, m, c, bind, nbind, xB)
    B = A(:, bind)
    [L, U] = lu(B)

    # Compute the reduced costs
    #
    [redc, aux] = reducedCost(A, c(bind) nbind, L, U)

    printf("Custos Reduzidos\n")
    print_vec(nbind, redc)

    # When aux = 0, reduced costs are all non-negative
    if aux == 0
        ind = 0
        vec = xB
        return
    endif

    # Convert nbind index to R^n index
    j = nbind(aux)

    # Find j-th basic direction
    dB = - U \ (L \ A(j))

    # If non-negative, this direction leads to cost = -Inf
    if dB >= 0
        vec = dB
        ind = -1
        return
    endif

    printf("\nEntra na base: %d\n", j)
    printf("\nDireção\n")
    print_vec(bind, dB)

    # Compute Theta*
    #
    [theta, aux] = thetaStep(xB, dB, m)

    # Convert bind index to R^n index
    i = bind(aux)

    printf("Theta*\n%f\n", theta)
    printf("\nSai da base: %d\n", i)

    # Swap indexes
    bind(find(bind == i))   = j
    nbind(find(nbind == j)) = i

    # Compute new vector
    vec = xB + theta*dB
    ind = 1
endfunction
