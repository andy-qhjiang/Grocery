% this is a program illustrating the wave propogation in 3D space (t, x,
% u(t,x)) and the initial value is given by u(0, x) = sin(x)

a = 2;        % Wave speed
L = 10;       % Length of the spatial domain
T = 2.8;        % Total time duration
dx = 0.05;     % Spatial step
dt = 1;     % Time step

x = 0:dx:L;   % Spatial grid
t = 0:dt:T;   % Time grid

figure(1)
clf
axis equal
hold on % Keep the current graph

% Loop through each time and spatial coordinate to plot the wave
for i = 1:length(t)
    % Calculate the y-values for the current time t(i)
    y = sin(x - a * t(i));
    
    % Plot the wave
    plot3(x, t(i) * ones(size(x)), y, '-', 'LineWidth', 5); % x remains the same for each time
end

% Define constant values for characteristics lines
characteristic_values = [0, 3]; % characteristics: x - at = -2, 0, 2

% Plot characteristic lines
for k = characteristic_values
    % Calculate the values of t for the characteristic line
    t_characteristic = (x - k) / a;
    
    % Ensure we plot only valid values within the time domain
    valid_index = t_characteristic >= 0 & t_characteristic <= T;

    % Plot the characteristic line in 3D
    plot3(x(valid_index), t_characteristic(valid_index), sin(x(valid_index) - a * t_characteristic(valid_index)), 'r--', 'LineWidth', 1.5);
end

grid on
xlabel('Space (x)');
ylabel('Time (t)');
zlabel('Amplitude');
title('Wave Visualization with Characteristic Lines');
view([15 15]);
xlim([-0.1, 8])
ylim([-0.1, 3])
hold off
