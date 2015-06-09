function Binv = updateBinv(Binv, u, out)
    for i = 1:size(u,1)
        if i == out
            Binv(i, :) /= u(i);
        else
            Binv(i, :) -= (u(i)/u(out)) * Binv(out, :);
        endif
    endfor
endfunction
