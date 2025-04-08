%% draw the illustration about Newton iterations and duality gap
clearvars
% m = 100; % number of constraints
% n = 50; % dimension of Euclidean space
% A = randn(m,n);
% lambda_star = [rand(n, 1); zeros(n,1)]; % first 50 constraints active
% c = -A'*lambda_star;
% b = ones(m,1);
% x = zeros(n,1); % which is initial point

q = sqrt(3);
m = 6;
n = 2;
A = [0 1;
    -q 1;
     -q -1;
     0 -1;
     q -1;
     q 1];

lambda_star = [rand(m/2, 1); zeros(m/2,1)]; % first m/2 constraints active
c = -A'*lambda_star;
b= [q; 2*q; 2*q; q; 2*q; 2*q];
x = zeros(n,1);

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
mu = [100, 50, 10, 2];
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
%%
legend(['\mu =', num2str(mu(1))], ['\mu =', num2str(mu(2))],...
        ['\mu =', num2str(mu(3))], ['\mu =', num2str(mu(4))]);

figure(2)
clf
hold on
x = -2:0.01:2;
y = -2:0.01:2;
[X, Y] = meshgrid(x,y);
Z = -sum(log(b-A*x));
contour(X,Y,Z,20);
plot(iter_pts(1,:), iter_pts(2,:), 'b-');
    
