% This is a program solving exercise1_3_1

%% initialize the wave
clc, clear
% Define spatial domains and time parameters
h_values = [1/10, 1/20, 1/40];
t_final = 4.8;
    
speed = 1;
h = h_values(2);
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

%% solve v^{n}_{m}

u = zeros(length(t), length(x)); % grid function v^{n}_{m}
u(1, :) = u0; % initial condition
u(:, 1) = zeros(length(t), 1);


% Call scheme_function for the chosen scheme_index
% scheme 1: Forward-time forward-space
% scheme 2: Forward-time backward-space
% scheme 3: Forward-time central-space
% scheme 4: leapfrog
% scheme 5: Lax-Friedrichs

scheme_index = 4; % different schemes as needed
u = scheme_compute(scheme_index, u, speed, 0.8);


%% Create a 3D surface plot of the solution

figure(2)
clf
axis equal
hold on


for i = 1:10:length(t) % choose larger spacing for a better view
    plot3(x, t(i)*ones(length(x), 1), u(i, :), 'o-', 'LineWidth', 1.5)
    plot3(x_standard, t(i)*ones(length(x_standard), 1), initial_fun(x_standard - speed*t(i)*ones(1,length(x_standard))), 'k-', 'LineWidth', 1)
end

title(['3D Surface Plot for h = ', num2str(h)]);
xlabel('Space (x)');
ylabel('Time (t)');
zlabel('Amplitude');
view([-34 27]);



