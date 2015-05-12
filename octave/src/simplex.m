function [ind v] = simplex (A, b, c, m, n, x)
    printf("SIMPLEX: Fase 2\n");

    % Vector starts with initial VBS
    v = x;

    % Find basic and non-basic indexes
    bind  = find(v ~= 0);
    nbind = find(v == 0);

    ind = 1;
    simplexstep = 0;
    while ind == 1;
        % Print iteration, basic variables and cost function
        printf("\n----------------------------------------\n")
        printf("\nIterando %d\n", simplexstep);
        print_bind(bind, v);
        printf("\nValor Função Objetivo: %f\n", c'*v);

        % Simplex iteration
        [v ind out in] = naiveStep(A, m, n, c, bind, nbind, v);

        % Update basic and non-basic indexes, if necessary
        if ind == 1
            bind(find(bind == out)) = in;
            nbind(find(nbind == in)) = out;
        endif

        % Next step
        simplexstep++;
    endwhile

    % Print corresponding solution/direction
    if ind == 0
        printf("Solução ótima encontrada com custo %f\n", c'*v);
    else
        printf("Direção associada ao custo -Inf\n");
    endif

    for i=1:n
        printf("%d  %f\n", i, v(i));
    endfor
endfunction
