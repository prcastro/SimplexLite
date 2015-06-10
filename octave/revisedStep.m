function [v d ind i j] = revisedStep(A, Binv, m, n, c, bind, nbind, v)
    % Compute the reduced costs
    [redc, j] = revisedReducedCost(A, Binv, c, bind, nbind);

    % When j = 0, reduced costs are all non-negative
    % and we found an optimal solution
    if j == 0
        d = zeros(n, 1);
        ind = 0;
        i = 0;
        return;
    endif

    % Find j-th basic direction
    d       = zeros(n, 1);
    d(bind) = - Binv*A(:,j);
    d(j)    = 1;

    % If non-negative, this direction leads to cost = -Inf
    if d >= 0
        ind = -1;
        i = 0;
        j = 0;
        return;
    endif

    % Index j is the one that enters the base
    printf("\nEnters the base: %d\n", j);

    % Print the direction
    printf("\nDirection\n");
    print_bind(bind, d);

    % Compute Theta*
    [theta, idx] = thetaStep(v(bind), d(bind), length(bind));

    % Convert bind index to R^n index
    % This index exits the base
    i = bind(idx);
    printf("\nLeaves the base: %d\n", i);

    % Compute new vector
    v += theta*d;
    ind = 1;
endfunction
