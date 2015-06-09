function [ind v d] = phaseTwo(A, b, c, m, n, v)
    printf("\n\nSIMPLEX: Fase 2");
    printf("\n========================================\n")

    % Find basic and non-basic indexes
    bind  = find(v ~= 0)';
    nbind = find(v == 0)';

    % Compute the inverse of the first basic matrix
    Binv = inv(A(:, bind));

    ind = 1;
    simplexstep = 0;
    while ind == 1;
        % Print iteration, basic variables and cost function
        printf("\nIterando %d\n", simplexstep);
        printf("----------------------------------------\n")
        print_bind(bind, v);
        printf("\nValor Função Objetivo: %f\n", c'*v);

        % Simplex iteration
        [v d ind out in] = revisedStep(A, Binv, m, n, c, bind, nbind, v);

        % Update basic and non-basic indexes and update the inverse of basic matrix, if necessary
        if ind == 1
            Binv = updateBinv(Binv, -d(bind)', find(bind == out));
            %Binv = updateBinv(Binv, -d', out);
            bind(find(bind == out)) = in;
            nbind(find(nbind == in)) = out;
            printf("\n----------------------------------------")
        endif

        % Next step
        simplexstep++;
    endwhile
endfunction
