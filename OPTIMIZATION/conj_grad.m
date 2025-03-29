function iterPoints = conj_grad(A, b, x, tol)
   
iterPoints = [];
r = b-A*x;
p = r;
while norm(r) > tol
    alpha = dot(r, r)/dot(A*p, p);
    x = x + alpha*p;
    iterPoints = [iterPoints, x];
    r_prev = r;
    r = b-A*x;

    % update p
    beta = dot(r, r)/dot(r_prev, r_prev);
    p = r + beta*p;
end

end