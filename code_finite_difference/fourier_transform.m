% This is aimed to show the modulus of Fourier transform satisfying
% Uncertainty Principle.

%% Define the function u(x)
clc, clear 
x = linspace(-5, 5, 1000); % x from -1 to 5
% u = exp(-x) .* (x >= 0);   % u(x) = e^(-x) for x >= 0, else 0
u = exp(-abs(x));  % u(x) = e^(-|x|) for all x

% Define xi for Fourier transform
xi = linspace(-10, 10, 1000); % xi range
% hat_u = 1 ./ (sqrt(2*pi) *(1 + 1i * xi)); % Fourier transform
hat_u = sqrt(2/pi) ./(1 + xi.*xi);

% Modulus of the Fourier transform
mod_hat_u = abs(hat_u);

%% Plotting u(x)
figure(1);
clf

hold on
plot(x, u, 'b','LineWidth', 1.5);


%% Plotting mod(hat_u(xi))
plot(xi, mod_hat_u, 'r', 'LineWidth', 1);
grid on;
