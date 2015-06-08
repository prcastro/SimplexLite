function [ind x] = phaseOne(A, b, m, n)
    % auxiliary problem:
    % MIN. sum(y_i)
    % S.T. Ax + y = b
    %      x, y >= 0

    printf("SIMPLEX: Fase 1");
    printf("\n========================================\n")

    % first BFS, x = 0, y = b
    v = [zeros(n, 1); b];

    % redefining
    A = [A, eye(m)];
    c = [zeros(n, 1); ones(m, 1)];
    n = n+m;

    % Find basic and non-basic indexes
    nbind = [1:(n-m)];
    bind  = [(n-m+1):n];

    ind = 1;
    simplexstep = 0;
    while ind == 1;
        % Print iteration, basic variables and cost function
        printf("\nIterando %d\n", simplexstep);
        printf("----------------------------------------\n")
        print_bind(bind, v);
        printf("\nValor Função Objetivo: %f\n", c'*v);

        % Simplex iteration
        [v d ind out in] = naiveStep(A, m, n, c, bind, nbind, v);

        % Update basic and non-basic indexes, if necessary
        if ind == 1
            bind(find(bind == out)) = in;
            nbind(find(nbind == in)) = out;
            printf("\n----------------------------------------")
        endif

        % Next step
        simplexstep++;
    endwhile % ind = 0, because the aux problem is feasible

    % if y != 0 the original problem is not feasible
    if v((n-m+1):n) != zeros(m, 1)
        ind = 1;
    endif

    x = v(1:(n-m));
endfunction
