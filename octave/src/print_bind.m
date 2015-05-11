function print_bind(bind, x)
    # Print "basic elements" of a vector
    for i=bind
        printf("%d  %f\n", i, x(i));
    endfor
endfunction
