% This is an example about discrete Fourier transformation

%% Parameters
M = 20;
h = 1 / M;  % Grid spacing
x = -2:h:2; % Define grid points from -2 to 2
v_m = zeros(size(x)); % Initialize grid function

% Calculate grid function v_m
for i = 1:length(x)
    if abs(x(i)) < 1
        v_m(i) = 1;  % Inside the interval (-1, 1)
    elseif abs(x(i)) == 1
        v_m(i) = 0.5; % On the boundary at |x| = 1
    else
        v_m(i) = 0;   % Outside the interval
    end
end

% Define the xi range for Fourier transform
xi = linspace(-10, 10, 1000); % Range for xi
hat_v = (h / sqrt(2 * pi)) .* sin(xi) .* cot(0.5 * h * xi); % Fourier transform

% Handle potential singularity at xi = 0 for cot function
hat_v(isnan(hat_v)) = 0; % Set NaN values to 0 due to cot(0)

%% Plotting
figure;

% Plot the grid function v_m
subplot(2, 1, 1);
plot(x, v_m, 'LineWidth', 2);
title('Grid Function v_m(x)');
xlabel('x');
ylabel('v_m');
grid on;
axis tight;
ylim([-0.5, 1.2]); % Limit y-axis for better visualization

%% Plot the Fourier transform |hat{v}(\xi)|
subplot(2, 1, 2);
plot(xi, hat_v, 'LineWidth', 2);
title('Fourier Transform |hat{v}(\xi)|');
xlabel('\xi');
ylabel('|\hat{v}(\xi)|');
grid on;
axis tight;

% Display the figure
sgtitle('Grid Function and its Fourier Transform');
