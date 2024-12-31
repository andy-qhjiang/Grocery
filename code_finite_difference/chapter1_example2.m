% This is a script to draw a wave coming from the following equation
% u_{t} +x*u_{x} = 0, with initial value u(0,x) = sin(2*pi*x) for 0<x<1

% we have compute that u(t,x) = sin(2*pi*x*e^{-t}) and 0<x*e^{-t}<1 which
% is 0<x<e^{t}) 

% Initialize time samples
t_samples = [0.5, 1, 1.5, 2];

figure;
hold on;
grid on;

% For each time sample
for i = 1:length(t_samples)
    t = t_samples(i);
    % Generate x values from 0 to e^t with step 0.1
    x = 0:0.01:exp(t);
    % Calculate wave values
    u = sin(2*pi*x.*exp(-t));
    % Plot in 3D
    plot3(x, t*ones(size(x)), u, 'LineWidth', 5);
end

% Add characteristic curves
t_char = 0:0.01:2.1;
% First characteristic: x = e^t
x_char1 = 2/3*exp(t_char);
% Second characteristic: x = e^t + 0.5
x_char2 = 1/4*exp(t_char);
% Plot characteristics and the z value can be obtained by one sample point
z1 =  sin(4*pi/3);
z2 = sin(pi/2);
% Plot characteristics with labels
plot3(x_char1, t_char, z1*ones(size(t_char)), 'r--', 'LineWidth', 2.5);
plot3(x_char2, t_char, z2*ones(size(t_char)), 'g--', 'LineWidth', 2.5);

% Add text labels near the end points of characteristics
text(x_char1(end), t_char(end), z1, 'x exp(-t)= 2/3', 'Color', 'r', 'FontSize', 12);
text(x_char2(end), t_char(end), z2, 'x exp(-t)= 1/4', 'Color', 'g', 'FontSize', 12);

% Add labels and title
xlabel('x');
ylabel('t');
zlabel('u(t,x)');
title('Wave Solution: u_t + xu_x = 0');
view([-30, 30]); % Set viewing angle

hold off;