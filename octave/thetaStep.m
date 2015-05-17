function [theta imin] = thetaStep(xB, dB, m)
    % Computes the largest step we can do
    % without leaving the polyhedra
    theta = Inf;
    for i=1:m
        if dB(i) < 0
            aux = - xB(i) / dB(i);
            if aux < theta
                theta = aux;
                imin = i;
            endif
        endif
    endfor
endfunction
