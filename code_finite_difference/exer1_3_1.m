% This is a program solving exercise1_3_1
% For values of x = -1:0.01:3, t = 0:0.01:2.4, 
% we are going to solve the wave equation u_t + u_x = 0

%% initialize the wave
clc, clear
% Define spatial domains and time parameters
h_values = [1/10, 1/20, 1/40];
t_final = 2.4;
speed = -1;
h = h_values(3);
x = -1:h:3;
x_standard = -1:0.01:3; % this is used to draw the original function u0 for contrast in figure 3

% Initialize u with initial condition
% type = 1: u(x, 0) = cos(pi * x)^2
% type = 2: u(x, 0) = 1 - 2 * sign(x) * x
u0 = initial_fun(x, 1);

figure(1)
clf
hold on
axis equal
plot(x, u0, 'o-');

%% solve v^{n}_{m}

% set up time spacing based on lambda
lambda = 0.8;
k = lambda*h;
t = 0: k :2.4;

u = zeros(length(t), length(x)); % grid function v^{n}_{m}
u(1, :) = u0; % initial condition
u(:, 1) = zeros(length(t), 1);


% Call scheme_function for the chosen scheme_index
% scheme 1: Forward-time forward-space
% scheme 2: Forward-time backward-space
% scheme 3: Forward-time central-space
% scheme 4: leapfrog
% scheme 5: Lax-Friedrichs

scheme_index = 5; % different schemes as needed
u = scheme_computation(scheme_index, u, speed, lambda);


%% Create a 3D surface plot of the solution
figure(2)
clf
axis equal
hold on


for i = 15:10:60 % choose larger spacing for a better view
    plot3(x, t(i)*ones(length(x), 1), u(i, :), 'o-', 'LineWidth', 1.5)
    plot3(x_standard, t(i)*ones(length(x_standard), 1), initial_fun(x_standard - speed*t(i)*ones(1,length(x_standard)), 1), 'k-', 'LineWidth', 1)
end

title(['3D Surface Plot for h = ', num2str(h)]);
xlabel('Space (x)');
ylabel('Time (t)');
zlabel('Amplitude');
view([-34 27]);

% Set the range of the y-axis
ylim([0.5, 2.5]);



