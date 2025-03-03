% Electric field visualization of two point charges with variable arrow length
% Parameters
q1 = 1;                  % Charge 1 (positive)
q2 = -1;                 % Charge 2 (negative)
pos1 = [10, 0];          % Position of charge 1
pos2 = [-10, 0];         % Position of charge 2
k = 8.99e9;              % Coulomb constant (N·m²/C²)

% Create grid (using finer grid where field changes rapidly, coarser elsewhere)
% For better visualization, we'll use non-uniform sampling
[x_fine, y_fine] = meshgrid(-40:1:40, -20:1:20);  % Fine grid for calculation
nx = size(x_fine, 1);
ny = size(x_fine, 2);

% Initialize electric field vectors
Ex = zeros(nx, ny);
Ey = zeros(nx, ny);

% Calculate the electric field at each point
for i = 1:nx
    for j = 1:ny
        % Current point position
        point = [x_fine(i,j), y_fine(i,j)];
        
        % Vector from charge 1 to current point
        r1 = point - pos1;
        dist1 = norm(r1);
        
        % Vector from charge 2 to current point
        r2 = point - pos2;
        dist2 = norm(r2);
        
        % Skip points very close to charges to avoid division by zero
        if dist1 < 0.5
            continue;
        end
        if dist2 < 0.5
            continue;
        end
        
        % Electric field due to charge 1 (E = k*q*r/|r|³)
        E1x = k * q1 * r1(1) / (dist1^3);
        E1y = k * q1 * r1(2) / (dist1^3);
        
        % Electric field due to charge 2
        E2x = k * q2 * r2(1) / (dist2^3);
        E2y = k * q2 * r2(2) / (dist2^3);
        
        % Superposition principle: Total field = sum of individual fields
        Ex(i,j) = E1x + E2x;
        Ey(i,j) = E1y + E2y;
    end
end

% Calculate field magnitude
E_magnitude = sqrt(Ex.^2 + Ey.^2);

% Use logarithmic scaling for better visualization (field varies greatly in magnitude)
log_E = log10(E_magnitude);
log_E(isinf(log_E)) = NaN;  % Replace infinities with NaN
log_E_min = min(log_E(:), [], 'omitnan');
log_E_max = max(log_E(:), [], 'omitnan');

% Create a non-uniform sampling for the quiver plot
% Use denser arrows where field changes rapidly (near charges)
% and fewer arrows in regions of more uniform field
[x_sample, y_sample] = meshgrid(-40:1.5:40, -20:1.5:20);

% Sample the electric field at these points using interpolation
Ex_sample = interp2(x_fine, y_fine, Ex, x_sample, y_sample, 'linear');
Ey_sample = interp2(x_fine, y_fine, Ey, x_sample, y_sample, 'linear');
E_mag_sample = sqrt(Ex_sample.^2 + Ey_sample.^2);

% Normalize direction but keep magnitude information for arrow length
% Use a moderate scaling to avoid extremely long arrows
Ex_norm = Ex_sample ./ E_mag_sample;
Ey_norm = Ey_sample ./ E_mag_sample;

% Apply a logarithmic scaling to the magnitude for arrow length
% This keeps arrows visible in regions of weaker field without having
% extremely long arrows in regions of strong field
log_E_sample = log10(E_mag_sample);
log_E_sample(isinf(log_E_sample)) = NaN;
scale_min = 0.1;  % Minimum arrow length
scale_max = 3.0;  % Maximum arrow length
scale_factor = scale_min + (scale_max - scale_min) * ...
               (log_E_sample - log_E_min) / (log_E_max - log_E_min);
scale_factor(isnan(scale_factor)) = scale_min;

% Create figure
figure;

% Plot electric field vectors with length proportional to magnitude
quiver(x_sample, y_sample, ...
       Ex_norm .* scale_factor, Ey_norm .* scale_factor, ...
       0, 'g', 'LineWidth', 1.2);

hold on;


% Plot charges
plot(pos1(1), pos1(2), 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r');  % Positive charge
plot(pos2(1), pos2(2), 'bo', 'MarkerSize', 12, 'MarkerFaceColor', 'b');  % Negative charge


% Add labels and colorbar
xlabel('x-position (m)', 'FontSize', 12);
ylabel('y-position (m)', 'FontSize', 12);
title('Electric Field of Two Point Charges', 'FontSize', 14);
axis equal
grid on


% Calculate potential instead of field magnitude for contours
V = zeros(nx, ny);
for i = 1:nx
    for j = 1:ny
        point = [x_fine(i,j), y_fine(i,j)];
        r1 = norm(point - pos1);
        r2 = norm(point - pos2);
        if r1 < 0.5 || r2 < 0.5
            V(i,j) = NaN;
        else
            % Potential due to point charges: V = k*q/r
            V(i,j) = k * q1 / r1 + k * q2 / r2;
        end
    end
end

% Plot equipotential lines (lines of constant potential)
contour(x_fine, y_fine, V, 25, 'k--', 'LineWidth', 0.5, 'HandleVisibility', 'off');

% Add legend
legend('Field vectors (length ∝ strength)', 'Positive charge (+q)',...
    'Negative charge (-q)',  'Location', 'best')

% Add text explanation
text(-39, -19, 'Note: Arrow length indicates relative field strength', 'FontSize', 10);