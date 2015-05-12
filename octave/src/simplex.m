function [ind v] = simplex (A, b, c, m, n, x)
    printf("SIMPLEX: Fase 2\n");

    v = x;

    # Boolean vector, indicating if an index is basic or not
    indexes = (v ~= 0);
    # Find basic and non-basic indexes
    bind  = find(indexes);
    nbind = find(~indexes);

    ind = 1;
    simplexstep = 0;
    while ind == 1;
        # Print stuff
        printf("\n----------------------------------------\n")
        printf("\nIterando %d\n", simplexstep);
        print_bind(bind, v);
        printf("\nValor Função Objetivo: %f\n", c'*v);

        # Simplex iteration
        [vec ind out in theta] = naiveStep(A, m, c, bind, nbind, v(bind));

        # This is boring.
        # We should compute d (both its basic and non-basic components)
        # and then add Theta*d to x
        # Also, beware when vec is a direction (cost = -Inf)
        if ind == 1
            v(bind) = vec;
            v(nbind) = 0;
            v(in)    = theta;

            bind(find(bind == out)) = in;
            nbind(find(nbind == in)) = out;
        endif

        simplexstep++;
    endwhile

    if ind == 0
        printf("Solução ótima encontrada com custo %f\n", c'*v);
    else
        printf("Direção associada ao custo -Inf\n");
    endif

    for i=1:n
        printf("%d  %f\n", i, v(i));
    endfor
endfunction
