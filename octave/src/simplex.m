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
        [ind vec] = naiveStep(A, m, c, bind, nbind, v(bind));
        v(bind) = vec;
        v(nbind) = 0;

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
