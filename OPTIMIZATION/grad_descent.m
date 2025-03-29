function iterPoints = grad_descent(A, b, x, tol)
   
iterPoints = [];
r = b-A*x;

while norm(r) > tol
    alpha = dot(r, r)/dot(A*r, r);
    x = x + alpha*r;
    iterPoints = [iterPoints, x];
    r = b-A*x;
end

end
     