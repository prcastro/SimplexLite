function print_bind(bind, x)
    # Print "basic elements" of a vector
    for i = 1:length(bind)
        printf("%d  %f\n", bind(i), x(bind(i)));
    endfor
endfunction
