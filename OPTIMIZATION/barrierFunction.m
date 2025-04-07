x = linspace(-3, -0.001, 100);
fun = @(x, t) -1/t *log(-x);
ymax = 5;

y1 = fun(x, 2);
y2 = fun(x,1);
y3 = fun(x, 0.5);

figure(1);
clf
plot([x, zeros(1, 10)], [zeros(size(x)), linspace(0,ymax,10)], 'r--', 'LineWidth', 2);
hold on
plot(x,y1, 'k-', 'LineWidth', 1);
plot(x,y2, 'g-', 'LineWidth', 1);
plot(x,y3, 'b-', 'LineWidth', 1);
legend('Indicator function I_{-}(x)', 't=2', 't=1', 't=0.5');
axis equal
title('Approximate indicator by logrithmic -1/t log(-x)')
ylim([-1.5, ymax]);
xlim([-5, 0.5]);
