% Simplex algorithm given the restrictions (with dimensions) and the cost-vector
function [ind x d] = simplex(A, b, c, m, n)
    % Find initial BFS using Simplex Phase One
    [ind x] = phaseOne(A, b, m, n);

    % Unfeasible problem
    if ind == 1
        printf("\nThe problem isn't feasible\n\n")
        return
    endif

    % Find optimal BFS using Simplex Phase Two
    [ind x d] = phaseTwo(A, b, c, m, n, x);

    % Print corresponding solution/direction
    printf("\n========================================\n")
    if ind == 0
        printf("\nOptimal BFS found with cost %f:\n", c'*x);
        for i=1:n
            printf("%d  %f\n", i, x(i));
        endfor
    else
        printf("\nDirection associated with cost -Inf:\n");
        for i=1:n
            printf("%d  %f\n", i, d(i));
        endfor
    endif

    % Sanity check
    if A*x != b
        error("Solution isn't feasible?!")
    endif
endfunction
