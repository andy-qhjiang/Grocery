% This is a program solving exercise1_3_1

%% initialize the wave
clc, clear
% Define spatial domains and time parameters
h_values = [1/10, 1/20, 1/40];
t_final = 2.4;
    
speed = 1;
h = h_values(1);
x = -1:h:3;
k = 0.8 * h;  % Calculating time-step based on lambda
t = 0:k:t_final;
x_standard = -1:0.01:3; % this is used to draw the original function u0 for contrast in figure 3

% Initialize u with initial condition
u0 = zeros(size(x));
u0(abs(x) <= 0.5) = cos(pi * x(abs(x) <= 0.5)).^2;
u0(abs(u0) < 1e-8) = 0;
u0_standard = zeros(size(x_standard));

figure(1)
clf
hold on
axis equal
plot(x, u0, 'o-');

u = zeros(length(t), length(x));
u(1, :) = u0; % initial condition
u(:, 1) = 0; % boundary condition


% Call scheme_function for the chosen scheme_index
% scheme 1: Forward-time forward-space
% scheme 2: Forward-time backward-space
% scheme 3: Forward-time central-space
% scheme 4: leapfrog
% scheme 5: Lax-Friedrichs

scheme_index = 3; % different schemes as needed
u = scheme_compute(scheme_index, u, speed, 0.8);

%% Create a 3D surface plot of the solution
figure(2)
clf
axis equal
hold on
for i = 1:length(t)
    plot3(x, t(i)*ones(length(x), 1), u(i, :), 'bo', 'LineWidth', 1.5)
end

title(['3D Surface Plot for h = ', num2str(h)]);
xlabel('Space (x)');
ylabel('Time (t)');
zlabel('Amplitude');
view([-34 27]);

%% Plot 2D slice at given t
specified_time = 2.0; % Example, change as needed
[~, time_index] = min(abs(t - specified_time));
figure(3)
clf
hold on
tmp = x_standard - speed*specified_time;
u0_standard(abs(tmp) <= 0.5) = cos(pi * tmp(abs(tmp) <= 0.5)).^2;
plot(x_standard, u0_standard, '-b', 'LineWidth', 2);
plot(x, u(time_index, :), 'or', 'LineWidth', 1.5);
xlabel('Space (x)');
ylabel(['u(t=', num2str(t(time_index)), ',x)']);
title(['Solution at t = ', num2str(t(time_index)), ' for h = ', num2str(h)]);
grid on;

