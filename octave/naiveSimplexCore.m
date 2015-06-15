% nAIVE Simplex given first BFS and the correspondent basic matrix
function [ind x d] = naiveSimplexCore(A, m, n, c, bind, nbind, x)
    ind = 1;
    simplexstep = 0;
    while ind == 1;
        % Print iteration, basic variables and cost function
        printf("\nIteration %d\n", simplexstep);
        printf("----------------------------------------\n")
        printf("Basic Feasible Solution (Basic Indexes):\n")
        print_bind(bind, x);
        printf("\nValue of cost function: %f\n", c'*x);

        % Simplex iteration
        [x d ind out in] = naiveStep(A, m, n, c, bind, nbind, x);

        % Update basic and non-basic indexes and update the inverse of basic matrix, if necessary
        if ind == 1
            bind(find(bind == out)) = in;
            nbind(find(nbind == in)) = out;
            printf("\n----------------------------------------")
        endif

        % Next step
        simplexstep++;
    endwhile
endfunction
