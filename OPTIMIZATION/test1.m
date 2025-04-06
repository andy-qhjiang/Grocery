clearvars
%A = [17 2; 2 7];
%b = [2; 2];
%x0= [0; 0];
A = [1 0; 0 10];
b = [0; 0];
x0 = [10; 1];

x_star = A\b;
tol = 10^-6;

iterPoint1 = [x0, grad_descent(A, b, x0, tol)];
iterPoint2 = [x0, conj_grad(A, b, x0, tol)];




f = @(x, y, A, b) -b(1)*x - b(2)*y + 0.5 * (A(1,1)*x.^2 + 2*A(1,2)*x.*y + A(2,2)*y.^2);
% Create a grid of x and y values
x = linspace(-2, 10, 100); % Adjust the range as needed
y = linspace(-2, 2, 100);
[X, Y] = meshgrid(x, y);

% Evaluate the function at the grid points
Z = f(X, Y, A, b);

%% Plot the contour
figure;
hold on
contour(X, Y, Z, 30);        % Draw 20 equidistant contour levels
plot(iterPoint1(1,:), iterPoint1(2,:), 'or-', 'MarkerSize',2);
plot(iterPoint2(1,:), iterPoint2(2,:), 'diamond g--', 'MarkerFaceColor', 'g');
plot([10, 0], [1, 0], '*--', 'MarkerSize', 8,'LineWidth', 2);
legend('contour of quadratic form', 'Grident descent', 'Conjugate descent', 'Newton method');
title('Comparison between descent methods');
xlabel('x');
ylabel('y');


