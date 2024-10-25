function u = scheme_compute(scheme_index, u, a, lambda)

    % Get spatial and temporal sizes
    [num_time_steps, num_space_steps] = size(u);

    % Time-stepping
    for n = 1:num_time_steps-1
        switch scheme_index

            case 1 % Forward-time forward-space scheme
                for m = 2:num_space_steps
                    u(n+1, m) = u(n, m) -a*lambda*(u(n,m+1)-u(n, m));
                end
                
                
            case 2 % Forward-time backward-space scheme
                for m = 2:num_space_steps
                    u(n+1, m) = u(n, m) - a * lambda * (u(n, m) - u(n, m-1));
                end
               

            case 3 % Forward-time central-space scheme
                for m = 2:num_space_steps-1
                    u(n+1, m) = u(n, m) - 0.5 * a * lambda * (u(n, m+1) - u(n, m-1));
                end
                

            case 4 % Leapfrog scheme
                if n == 1 % Special treatment for first step
                    for m = 2:num_space_steps
                        u(n+1, m) = u(n, m) - a * lambda * (u(n, m) - u(n, m-1));
                    end
                else
                    for m = 2:num_space_steps-1
                        u(n+1, m) = u(n-1, m) - a * lambda * (u(n, m+1) - u(n, m-1));
                    end
                end
                

            case 5 % Lax-Friedrichs scheme
                for m = 2:num_space_steps-1
                    u(n+1, m) = 0.5 * (u(n, m+1) + u(n, m-1)) - 0.5 * a * lambda * (u(n, m+1) - u(n, m-1));
                end

            case 6 % Leapfrog scheme with boundary condition on right hand side
                u(:, num_space_steps) = 0;
                if n == 1 % Special treatment for first step
                    for m = 2:num_space_steps-1
                        u(n+1, m) = u(n, m) - a * lambda * (u(n, m) - u(n, m-1));
                    end
                else
                    for m = 2:num_space_steps-1
                        u(n+1, m) = u(n-1, m) - a * lambda * (u(n, m+1) - u(n, m-1));
                    end
                end
                
                
            otherwise
                error('Invalid scheme index. Choose 1, 2, 3, 4 or 5.');
        end
    end
end
