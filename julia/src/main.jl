function simplex(A, b, c, m, n, x)
    println("Simplex Fase 2")

    v = x
    indexes = (v .!= 0)
    bind = find(indexes)
    nbind = find(!indexes)

    ind = 1
    it = 0
    while ind == 1
        println("Iterando ", it)
        print_bind(bind, v)
        println("Valor Função Objetivo: ", c'v)

        ind, vec = naiveStep!(A, m, c, bind, nbind, v(bind))
        v(bind) = vec
        v(nbind) = 0

        it += 1
    end

    if ind == 0
        println("Solução ótima encontrada com custo", c'v)
    else
        printf("Direção associada ao custo -Inf")
    end

    for i in 1:n
        @printf("%d  %f\n", i, v(i))
    end
end


function simplex_step(A, m, c, bind, nbind, xb)
    B = A[:, bind]
    LU = lufact(B)
    L, U = LU[:L], LU[:U]


    redc, aux =
    print_redcosts(redc)

    if min(redc) >= 0
        return
    end

    db = - U * inv(L * inv(A))

    if db .>= 0
        return
    end

    theta, i = thetaStep(xB, dB, m)

    return
end
