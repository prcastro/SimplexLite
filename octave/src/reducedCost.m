function [redc ind] = reducedCost(A, c, bind, nbind, L, U)
    % p = (c(bind)' * inv(A(bind)))'
    p = L' \ (U' \ c(bind));

    # Calculate the reduced costs
    redc = c(nbind)' - p'*A(:, nbind);

    # Find the negative costs, if any
    negs = find(redc < 0);

    # If no negative costs are found, return ind = 0
    if length(negs) == 0
        ind = 0;
        return;
    endif

    # Return the first negative cost
    ind = negs(1);
endfunction