% This is an illutration of directional derivatoin of multi-variable
% function. 

%%
clearvars

% Create a grid of points
[x, y] = meshgrid(linspace(-5, 5, 400));
z = x.^2+y.^2;

% Define the plane equation
plane_equation = 2*x - y - 4;

% Create mask and apply it
mask = plane_equation < 0;
z_masked = z;
z_masked(~mask) = NaN;

%% Create the figure and 3D plot

figure;
% Plot the surface
surf(x, y, z_masked, 'Edgecolor', 'none', 'FaceAlpha','0.8');
view([-1.5, 52]);
colormap('summer');
hold on
grid on

% Plot the intersection curve
curve_x = linspace(-0.5, 4.5, 500);
curve_y = 2 * curve_x - 4;
curve_z = curve_x.^2 + curve_y.^2;
plot3(curve_x, curve_y, curve_z, 'r', 'LineWidth', 3);

% Plot the plane 2x-y-4=0 in gray style
plane_X = repmat(curve_x, 100, 1);
plane_Y = 2.*plane_X - 4;
z_range = linspace(-0.2, 40, 100);
plane_Z = repmat(z_range', 1, size(plane_X, 2));

surf(plane_X, plane_Y, plane_Z, ...
    'FaceColor', [172, 221, 222]/255, ... % Light crystal color
    'EdgeColor', 'none', ... % Remove black edges
    'FaceAlpha', 0.6); %  smaller parameter is more transparent

plot3(2, 0, 4, 'ko', 'MarkerFaceColor', 'k');
quiver3([2 2], [0 0], [4 4], [1 1], [0 2], [0 0], 'k', 'LineWidth', 1);
text(2.5, -0.1, 4, 'dx');
text(2.6, 1.1, 4, 'ds');

% Labels and legend
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Directional derivative of x^2+y^2 at (2, 0) along (1,2)');
legend('surface x^2+y^2', 'Intersection Curve', 'plane 2x-y=4', 'point (2,0,4)', 'differential dx and ds');

