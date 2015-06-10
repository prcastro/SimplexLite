function [ind v d] = phaseTwo(A, b, c, m, n, v)
    printf("\n\nSIMPLEX: Phase 2");
    printf("\n========================================\n")

    % Find basic and non-basic indexes
    bind  = find(v ~= 0)';
    nbind = find(v == 0)';

    %% Revised Simplex
    % Compute the inverse of the first basic matrix
    Binv = inv(A(:, bind));
    [ind, v, d] = revisedSimplexCore(A, Binv, m, n, c, bind, nbind, v);

    %% Naive Simplex
    % [ind, v, d] = naiveSimplexCore(A, m, n, c, bind, nbind, v);
endfunction
