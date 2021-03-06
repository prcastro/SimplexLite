function [ind x d] = phaseTwo(A, b, c, m, n, x)
    printf("\n\nSIMPLEX: Phase 2");
    printf("\n========================================\n")

    % Find non-basic indexes
    nbind = find(x == 0)';
    % Drop last indexes if we have more than n-m non-basic indexes
    length(nbind) > (n-m) && (nbind = nbind(1:n-m));
    % Find basic indexes
    bind = [];
    for i = 1:length(x)
        if all(i != nbind)
            bind = [bind, i];
        endif
    endfor

    %% Revised Simplex
    % Compute the inverse of the first basic matrix
    Binv = inv(A(:, bind));
    [ind x d] = revisedSimplexCore(A, Binv, m, n, c, bind, nbind, x);
endfunction
