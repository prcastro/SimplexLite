function [ind v] = simplex (A, b, c, m, n, x)
endfunction

function naiveStep(A, b_ind, x_B)
    B = A(:, b_ind)
    [L, U] = lu(B)
    not_b = []
    for i=1:size(A, )
        not_b = [not_b, ]
    endfor

endfunction
