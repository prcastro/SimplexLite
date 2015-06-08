function [ind v] = simplex (A, b, c, m, n)
    % separated function implementing Simplex Phase One
    [ind v] = phaseOne(A, b, m, n);

    if ind == 1
        printf("The original problem isn't feasible")
        return
    endif

    [ind v] = phaseTwo(A, b, c, m, n, v)

    % Print corresponding solution/direction
    printf("\n========================================\n")
    if ind == 0
        printf("\nSolução ótima encontrada com custo %f\n", c'*v);
    else
        printf("\nDireção associada ao custo -Inf\n");
    endif

    for i=1:n
        printf("%d  %f\n", i, v(i));
    endfor
endfunction
