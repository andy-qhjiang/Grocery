function iterPoints = grad_descent_backtrack(A, b, x, tol)
   
iterPoints = [];
r = b-A*x;

while norm(r) > tol
    % backtracking line searcstep_size
    beta = 0.1;
    alpha = 0.01;
    step_size = 1;
    delta_x = -A*x;
    f_current = 0.5*x'*A*x;
    f_new = 0.5*(x+step_size*delta_x)'*A*(x+step_size*delta_x);
    while f_new > f_current
        step_size = beta*step_size;
        f_new = 0.5*(x+step_size*delta_x)'*A*(x+step_size*delta_x);
    end

    while f_new > f_current + alpha*step_size*delta_x'*(A*x)
        step_size = beta*step_size;
        f_new = 0.5*(x+step_size*delta_x)'*A*(x+step_size*delta_x);
    end
    x = x + step_size*delta_x;
    iterPoints = [iterPoints, x];
    r = b-A*x;
end

end
     