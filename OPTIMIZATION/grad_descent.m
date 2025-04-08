function iterPoints = grad_descent(A, b, x, tol)
   
iterPoints = [];
r = b-A*x;

while norm(r) > tol
    h = dot(r, r)/dot(A*r, r); % steepest descent
    x = x + h*r;
    iterPoints = [iterPoints, x];
    r = b-A*x;
end

end
     