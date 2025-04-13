%% draw the illustration about Newton iterations and duality gap
clearvars

m = 100; % number of constraints
n = 50; % dimension of Euclidean space
A = randn(m,n);
lambda_star = [rand(n, 1); zeros(n,1)]; % first 50 constraints active
c = -A'*lambda_star;
b = ones(m,1);
x = zeros(n,1); % which is initial point

% q = sqrt(3);
% m = 6;
% n = 2;
% A = [0 1;
%     -q 1;
%      -q -1;
%      0 -1;
%      q -1;
%      q 1];
% 
% lambda_star = [rand(m/2, 1); zeros(m/2,1)]; % first m/2 constraints active
% c = -A'*lambda_star;
% b= [q; 2*q; 2*q; q; 2*q; 2*q];
% x = zeros(n,1);

% Parameters
t_inv = 1; % reciprocal of time
gap_tolerance = 1e-6;
alpha = 0.01; % Backtracking parameter
beta = 0.5;
newton_tolerance = 1e-5;
x_star = linprog(c, A, b);
fprintf("The answer computed by linprog is %.4f\n", c'*x_star);

%%
figure(1)
clf
ylim([10^-7, 10]); 
xlabel('Newton iterations')
ylabel('duality gap');
hold on
mu = [100, 50, 2, 10];
for i = 1:length(mu)
    [step, diff, iter_pts] = interior_PM(A, b, x, c, t_inv, mu(i),gap_tolerance,...
                        newton_tolerance, alpha, beta, m);
    num_iter = zeros(size(step));
    num_iter(1)=step(1);
    for i=2:length(num_iter)
        num_iter(i)= num_iter(i-1) + step(i);
    end
    x_drawn = reshape(repmat(num_iter,2,1), 1, 2*length(num_iter));
    x_drawn = x_drawn(2:end);
    y_drawn = reshape(repmat(diff,2,1), 1, 2*length(num_iter));
    y_drawn = y_drawn(1:end-1);
    semilogy(x_drawn, y_drawn, '-');
    set(gca, 'YScale', 'log'); 
end
legend(['\mu =', num2str(mu(1))], ['\mu =', num2str(mu(2))],...
        ['\mu =', num2str(mu(3))], ['\mu =', num2str(mu(4))]);

%% For illustrations about central path

% figure(2)
% clf
% hold on
% axis equal
% x = -1:0.01:1;
% y = -1:0.01:1;
% [X, Y] = meshgrid(x, y);
% 
% % Reshape grid points into 2xN matrix (N = numel(X))
% gridPoints = [X(:)'; Y(:)']; 
% 
% % Compute A * gridPoints (6xN matrix)
% A_grid = A * gridPoints;
% 
% % Ensure b is a column vector and compute b - A_grid
% b_col = b(:);
% diff = b_col - A_grid;
% 
% % Compute log terms and sum over rows (each column is a grid point)
% log_terms = log(diff);
% sum_log = sum(log_terms, 1);
% 
% % Reshape the result back to match the grid
% Z = -reshape(sum_log, size(X));
% Z2 = c(1)*X+c(2)*Y;
% 
% contour(X,Y,Z,20);
% contour(X,Y,Z2, 20);
% plot(iter_pts(1,:), iter_pts(2,:), 'rs-');
% fill([2, 1, -1, -2, -1, 1], [0, q, q, 0, -q, -q], 'cyan', 'FaceAlpha', 0.2);
% 
% 
% % Add text labels for each point
% for i = 1:2:8  % Iterate over each point in the array
%     point = iter_pts(:, i);
%     text(point(1), point(2), ['x^{*}(' num2str((i-1)*10) ')'], ...
%          'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
% end

    
