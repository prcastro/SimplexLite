function [ind v d] = phaseTwo(A, b, c, m, n, v)
    printf("\n\nSIMPLEX: Phase 2");
    printf("\n========================================\n")

    % Find non-basic indexes
    nbind = find(v == 0)';
    # Drop last indexes if we have more than n-m non-basic indexes
    length(nbind) > (n-m) && (nbind = nbind(1:n-m));
    # Find basic indexes
    bind = [];
    for i = 1:length(v)
        if all(i != nbind)
            bind = [bind, i];
        endif
    endfor

    %% Revised Simplex
    % Compute the inverse of the first basic matrix
    Binv = inv(A(:, bind));
    [ind, v, d] = revisedSimplexCore(A, Binv, m, n, c, bind, nbind, v);

    %% Naive Simplex
    % [ind, v, d] = naiveSimplexCore(A, m, n, c, bind, nbind, v);
endfunction
