function [ind v] = simplex (A, b, c, m, n, x)
endfunction

function [ind v] = naiveStep(A, m, c, bind, xB)
    B = A(:, bind)
    [L, U] = lu(B)

    [redcj, j] = reducedCost(A, c, bind, L, U)
    if j == 0
        ind = 0
        v = xB
        return
    endif

    y = L \ A(j)
    dB = - (U \ y)

    if dB >= 0
        v = dB
        ind = -1
        return
    endif

    [theta, i] = thetaStep(xB, dB, m)

    bind(i) = j
    v = xB + theta*dB
    ind = 1
endfunction

function [theta imin] = thetaStep(xB, dB, m)
    theta = Inf
    for i=1:m
        if dB(i) < 0
            aux = - xB(i) / dB(i)
            if aux < theta
                theta = aux
                imin = i
            endif
        endif
    endfor
endfunction

function [redcj ind] = reducedCost(A, c, bind, L, U)
    cB = c(bind)
    for j=1:m
        if any(j == bind)
            continue;
        endif

        y = U' \ cB
        p = L' \ y

        redcj = c(j) - p'*A(:,j)
        if redcj < 0
            ind = j
            return
        endif
    endfor

    ind = 0
endfunction
