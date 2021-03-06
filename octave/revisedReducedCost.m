function [redc ind] = revisedReducedCost(A, Binv, c, bind, nbind)
    printf("Reduced Costs:\n");

    % Calculate the reduced costs in a vectorized way
    p_T = c(bind)'*Binv; % p is a transposed vector here

    % Compute reduced costs until find the first negative one
    for i = nbind
        % Compute the reduced cost
        redc = c(i) - (p_T)*A(:, i);

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
