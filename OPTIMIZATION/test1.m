clearvars
A = [17 2; 2 7];
b = [2; 2];
x0= [0; 0];

x_star = A\b;
tol = 10^-6;

iterPoint1 = [x0, grad_descent(A, b, x0, tol)];
iterPoint2 = [x0, conj_grad(A, b, x0, tol)];




f = @(x, y) -2*x - 2*y + 0.5 * (17*x.^2 + 4*x.*y + 7*y.^2);
% Create a grid of x and y values
x = linspace(0, 0.2, 100); % Adjust the range as needed
y = linspace(0, 0.3, 100);
[X, Y] = meshgrid(x, y);

% Evaluate the function at the grid points
Z = f(X, Y);

% Plot the contour
figure;
hold on
contour(X, Y, Z, 20);        % Draw 20 equidistant contour levels
plot(iterPoint1(1,:), iterPoint1(2,:), 'o-', 'MarkerFaceColor', 'r');
plot(iterPoint2(1,:), iterPoint2(2,:), 'diamond--', 'MarkerFaceColor', 'g');
title('Contour Plot of f(x, y)');
xlabel('x');
ylabel('y');


