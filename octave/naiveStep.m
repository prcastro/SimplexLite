function [v ind i j] = naiveStep(A, m, n, c, bind, nbind, v)
    % Compute B and its LU decomposition
    B = A(:, bind);
    [L, U] = lu(B);

    % Compute the reduced costs
    [redc, idx] = reducedCost(A, c, bind, nbind, L, U);
    printf("Custos Reduzidos\n");
    print_vec(nbind, redc);

    % When idx = 0, reduced costs are all non-negative
    % and we found an optimal solution
    if idx == 0
        ind = 0;
        i = 0;
        j = 0;
        return;
    endif

    % Convert nbind index to R^n index
    j = nbind(idx);

    % Find j-th basic direction
    d       = zeros(n, 1);
    d(bind) = - (U \ (L \ A(:, j)));
    d(j)    = 1;

    % If non-negative, this direction leads to cost = -Inf
    if d >= 0
        % We return v as the direction that leads to cost = -Inf
        v = d;
        ind = -1;
        i = 0;
        j = 0;
        return;
    endif

    % Index j is the one that enters the base
    printf("\nEntra na base: %d\n", j);

    % Print the direction
    printf("\nDireção\n");
    print_bind(bind, d);

    % Compute Theta*
    [theta, idx] = thetaStep(v(bind), d(bind), length(bind));
    printf("\nTheta*\n%f\n", theta);

    % Convert bind index to R^n index
    % This index exits the base
    i = bind(idx);
    printf("\nSai da base: %d\n", i);

    % Compute new vector
    v += theta*d;
    ind = 1;
endfunction
