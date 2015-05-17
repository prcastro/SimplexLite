function print_vec(indexes, v)
    % Print a vector and correspondent indexes
    for i=1:length(v)
        printf("%d  %f\n", indexes(i), v(i));
    endfor
endfunction
