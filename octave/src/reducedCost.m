function [redc ind] = reducedCost(A, c, bind, nbind, L, U)
    % Calculate the reduced costs in a vectorized way
    p = L' \ (U' \ c(bind)); % p = (c(bind)' * inv(A(bind)))'
    redc = c(nbind)' - p'*A(:, nbind);

    % Find the negative costs, if any
    negs = find(redc < 0);

    % If no negative costs are found, return ind = 0
    if length(negs) == 0
        ind = 0;
        return;
    endif

    % Return the first negative cost
    ind = negs(1);
endfunction
