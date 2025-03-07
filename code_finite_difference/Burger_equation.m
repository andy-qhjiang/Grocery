% Create mesh grid for x and t
[X, T] = meshgrid(linspace(0, 1, 100), linspace(0, 0.2, 100));
Z = zeros(size(X));

% Calculate u(x,t) for each point
for i = 1:size(X, 1)
    for j = 1:size(X, 2)
        x = X(i,j);
        t = T(i,j);

        if t == 0
            if x < 0.2
                Z(i,j) = 1;
            else
                Z(i,j) = 2;
            end
        else
            if x < 0.2 + 2*t
                Z(i,j) = 1;
            elseif x > 0.2 + 4*t
                Z(i,j) = 2;
            else
                Z(i,j) = (x - 0.2)/(2*t);
            end
        end
    end
end

% % Calculate u(x,t) for each point
% for i = 1:size(X, 1)
%     for j = 1:size(X, 2)
%         x = X(i,j);
%         t = T(i,j);
% 
%         if t == 0
%             if x < 0.2
%                 Z(i,j) = 2;
%             else
%                 Z(i,j) = 1;
%             end
%         else
%             if x < 0.2 + 3*t
%                 Z(i,j) = 2;
%             else
%                 Z(i,j) = 1;
%             end
%         end
%     end
% end

% Create 3D surface plot
figure;
surf(X, T, Z, 'EdgeColor', 'none');
colormap('jet');
colorbar;

% Add labels and title
xlabel('x');
ylabel('t');
zlabel('u(x,t)');
title('Solution of Burgers'' Equation');

% Set viewing angle
view(-30, 30);

% Add grid
grid on;

% Make the plot look nicer
lighting phong;
material shiny;
camlight;