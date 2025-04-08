function [step, diff, iter_pts] = interior_PM(A, b, x, c, t_inv, mu, gap_tolerance, newton_tolerance, alpha, beta, m)
    step = 0;
    diff = m*t_inv;
    iter_pts = x;
    while m * t_inv > gap_tolerance
        % Newton method for centering
        count = 0;
        while true
            s = b - A * x;
            grad = c + t_inv * (A' * (1 ./ s));
            hess = t_inv * (A' * diag(s .^ (-2)) * A);
            delta_x = -hess \ grad;
            decrement = delta_x' * hess * delta_x;
    
            if decrement < 2*newton_tolerance
                step = [step, count];
                break;
            end
    
            % Backtracking line search
            t = 1;
            while any(b - A * (x + t * delta_x) <= 0)
                t = beta * t;
            end
            f_current = c' * x - t_inv * sum(log(s));
            f_new = c' * (x + t * delta_x) - t_inv * sum(log(b - A * (x + t * delta_x)));
            while f_new > f_current + alpha * t * grad' * delta_x
                t = beta * t;
                f_new = c' * (x + t * delta_x) - t_inv * sum(log(b - A * (x + t * delta_x)));
            end
            x = x + t * delta_x;
            iter_pts = [iter_pts, x];
            count = count+1;
        end
        diff = [diff, m*t_inv];
        t_inv = t_inv / mu; % increase time / reduce t_inv
    end
    disp(['optimal value:', num2str(c'*x)]);
end