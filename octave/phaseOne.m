function [ind x] = phaseOne(A, b, m, n)
    % auxiliary problem:
    % MIN. sum(y_i)
    % S.T. Ax + y = b
    %      x, y >= 0

    printf("SIMPLEX: Phase 1");
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

    %% Revised Simplex
    % Compute the inverse of the first basic matrix
    Binv = inv(A(:, bind));
    [ind v d] = revisedSimplexCore(A, Binv, m, n, c, bind, nbind, v);

    % Here ind = 0, since the auxiliary problem is feasible

    % if y != 0 the original problem is not feasible
    if any(roundn(v((n-m+1):n), 8) ~= zeros(m, 1))
        ind = 1;
        printf("HERE")
    endif

    x = v(1:(n-m));
endfunction

% Round v to n-th decimal place
function v = roundn(v, n)
    factor = 10^n;
    v = round(v*factor)/factor;
endfunction
