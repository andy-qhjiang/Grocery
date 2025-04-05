%% we construct the following LP which is feasible for primal and dual
clearvars
m = 100;
n = 50;
A = randn(m,n);
lambda_star = [rand(50, 1); zeros(50,1)]; % first 50 constraints active
c = -A'*lambda_star;
b = ones(m,1);
x = zeros(n,1); % which is initial point

% Parameters
mu = 1; % Initial duality gap = m*mu = 100
sigma = 10; % mu reduction factor
gap_tolerance = 1e-6;
alpha = 0.01; % Backtracking parameter
beta = 0.5;
newton_tolerance = 1e-5;
x_star = linprog(c, A, b);

%% Barrier method

while m * mu > gap_tolerance
    % Newton method for centering
    while true
        s = b - A * x;
        grad = c + mu * (A' * (1 ./ s));
        hess = mu * (A' * diag(s .^ (-2)) * A);
        delta_x = -hess \ grad;
        decrement = sqrt(delta_x' * hess * delta_x);
        
        if decrement < newton_tolerance
            break;
        end
        
        % Backtracking line search
        t = 1;
        while any(b - A * (x + t * delta_x) <= 0)
            t = beta * t;
        end
        f_current = c' * x - mu * sum(log(s));
        f_new = c' * (x + t * delta_x) - mu * sum(log(b - A * (x + t * delta_x)));
        while f_new > f_current + alpha * t * grad' * delta_x
            t = beta * t;
            f_new = c' * (x + t * delta_x) - mu * sum(log(b - A * (x + t * delta_x)));
        end
        x = x + t * delta_x;
    end
    mu = mu / sigma; % Reduce mu
end

% Result
p_star = c' * x;
disp(['Optimal value: ', num2str(p_star)]);