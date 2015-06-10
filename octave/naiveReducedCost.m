function [redc ind] = naiveReducedCost(A, c, bind, nbind, L, U)
    printf("Custos Reduzidos\n");

    % Calculate the reduced costs in a vectorized way
    p = L' \ (U' \ c(bind)); % p = (c(bind)' * inv(A(bind)))'

    % Compute reduced costs until find the first negative one
    for i = nbind
        % Compute the reduced cost
        redc = c(i) - p'*A(:, i);

        % Print the computed reduced cost
        printf("%d  %f\n", i, redc);

        % Return if negative
        if redc < 0
            ind = i;
            return;
        endif
    endfor

    % If no negative costs are found, return ind = 0 and redc = 0
    redc = 0;
    ind = 0;
    return;
endfunction
