% Define time and initial points
t = linspace(0, 0.5, 100); % Small t to see early behavior
xi_left = linspace(-1, 0, 10); % xi < 0
xi_right = linspace(0, 1, 10); % xi >= 0

% Characteristics
figure;
hold on;
% For xi < 0, speed = 4
for xi = xi_left
    x = xi + 4 * t;
    x(x > 3*t) = NaN;
    plot(x, t, 'b-', 'LineWidth', 1);
end
% For xi >= 0, speed = 2
for xi = xi_right
    x = xi + 2 * t;
    x(x<3*t) = NaN;
    plot(x, t, 'r-', 'LineWidth', 1);
end

% Shock path
x_shock = 3 * t;
plot(x_shock, t, 'k--', 'LineWidth', 2);

% Formatting
xlabel('x');
ylabel('t');
title('Characteristics for Burgers'' Equation');

%
h1 = plot(NaN, NaN, 'b-', 'LineWidth', 1);
h2 = plot(NaN, NaN, 'r-', 'LineWidth', 1);
h3 = plot(NaN, NaN, 'k--', 'LineWidth', 2);
legend([h1, h2, h3], 'u = 2 (x < 0)', 'u = 1 (x \geq 0)', 'Shock Path');
grid on;
axis([-1.1 1.1 0 0.5]);
hold off;