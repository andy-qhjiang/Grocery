clc, clear
% Define the surface function
f = @(x, y) x.^2 + y.^2;

% Create a grid of points
[x, y] = meshgrid(linspace(-5, 5, 400));
z = f(x, y);

% Define the plane equation
plane_equation = 2*x - y - 4;

% Create mask and apply it
mask = plane_equation < 0;
z_masked = z;
z_masked(~mask) = NaN;

% Create the figure and 3D plot
figure;
ax = axes('Parent', gcf);
view(ax, 3);

% Plot the surface
surf(x, y, z_masked, 'EdgeColor', 'none', 'FaceAlpha', 0.8);
colormap('jet');

hold on
grid on


% Plot the intersection curve
curve_x = linspace(-0.5, 4.5, 500);
curve_y = 2 * curve_x - 4;
curve_z = curve_x.^2 + curve_y.^2;
plot3(curve_x, curve_y, curve_z, 'r', 'LineWidth', 3, 'DisplayName', 'Intersection Curve');

% Plot the plane 2x-y-4=0 in gray style
plane_X = repmat(curve_x, 300, 1);
plane_Y = 2.*plane_X - 4;
z_range = linspace(-0.2, 40, 300);
plane_Z = repmat(z_range', 1, size(plane_X, 2));

surf(plane_X, plane_Y, plane_Z, ...
    'FaceColor', [0.7 0.7 0.7], ... % Light gray color
    'EdgeColor', 'none', ... % Remove black edges
    'FaceAlpha', 0.8); % More transparent

quiver3([2 2], [0 0], [4 4], [1 1], [0 2], [0 0], 'k', 'LineWidth', 2, 'DisplayName', 'Direction of dx and ds');
text(2.5, -0.1, 4, 'dx');
text(2.6, 1.1, 4, 'ds');

% Labels and legend
xlabel('X');
ylabel('Y');
zlabel('Z');
legend;

hold off;