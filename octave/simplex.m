% Simplex algorithm given the restrictions (with dimensions) and the cost-vector
function [ind v d] = simplex(A, b, c, m, n)
    % Find initial BFS using Simplex Phase One
    [ind v] = phaseOne(A, b, m, n);

    % Unfeasible problem
    if ind == 1
        printf("\nThe original problem isn't feasible")
        return
    endif

    % Find optimal BFS using Simplex Phase Two
    [ind v d] = phaseTwo(A, b, c, m, n, v);

    % Print corresponding solution/direction
    printf("\n========================================\n")
    if ind == 0
        printf("\nOptimal BFS found with cost %f:\n", c'*v);
        for i=1:n
            printf("%d  %f\n", i, v(i));
        endfor
    else
        printf("\nDirection associated with cost -Inf:\n");
        for i=1:n
            printf("%d  %f\n", i, d(i));
        endfor
    endif

    % Sanity check
    if A*v != b
        error("Solution isn't feasible?!")
    endif
endfunction
