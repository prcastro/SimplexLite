function [ind v d] = simplex (A, b, c, m, n)
    % find first BFS using Simplex Phase One
    [ind v] = phaseOne(A, b, m, n);

    % unfeasible problem
    if ind == 1
        printf("The original problem isn't feasible")
        return
    endif

    % find optimal BFS using Simplex Phase Two
    [ind v d] = phaseTwo(A, b, c, m, n, v);

    % Print corresponding solution/direction
    printf("\n========================================\n")
    if ind == 0
        printf("\nSolução ótima encontrada com custo %f\n", c'*v);
        for i=1:n
            printf("%d  %f\n", i, v(i));
        endfor
    else
        printf("\nDireção associada ao custo -Inf\n");
        for i=1:n
            printf("%d  %f\n", i, d(i));
        endfor
    endif

    % Sanity check
    if A*v != b
        error("Solution isn't feasible?!")
    endif
endfunction
