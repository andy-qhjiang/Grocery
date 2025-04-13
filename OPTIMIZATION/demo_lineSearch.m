% This is an illutration of directional derivatoin of multi-variable
% function. 

%%
clearvars

% Create a grid of points
[x, y] = meshgrid(linspace(-20, 20, 500));
% z = x.^2+y.^2;
z = 0.5*(x.^2+10*y.^2);
figure;
% Plot the surface
surf(x, y, z, 'Edgecolor', 'none', 'FaceAlpha','0.8');
colormap('summer');
hold on
grid on


%% Plot the intersection plane based on gradient
X = -5:0.1:25;
Y = X - 9;
plot3(10, 1, 55, 'r s', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
plane_X = repmat(X, 100, 1);
plane_Y = repmat(Y, 100, 1);
z_range = linspace(0, 2000, 100);
plane_Z = repmat(z_range', 1, size(plane_X, 2));

surf(plane_X, plane_Y, plane_Z, ...
    'FaceColor', [172, 221, 222]/255, ... % Light crystal color
    'EdgeColor', 'none', ... % Remove black edges
    'FaceAlpha', 0.6); %  smaller parameter is more transparent

% Labels and legend
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('surface 0.5*(x^2+10y^2)', 'point(10, 1, 55)', 'intersection')
view([25, 65]);


