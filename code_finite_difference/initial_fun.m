% This is intial function for the wave equation, 
% g(x) = v(0,x) for t=0.
function y = initial_fun(x, choice)
    % Initialize the output array
    y = zeros(size(x));
    
    % Loop through each element in x
    for i = 1:length(x)
        if abs(x(i)) <= 0.5
            switch choice
                case 1
                    % First choice: y(i) = cos(pi * x(i))^2
                    y(i) = cos(pi * x(i))^2;
                case 2
                    % Second choice: y(i) = 1 - 2 * sign(x(i)) * x(i)
                    y(i) = 1 - 2 * sign(x(i)) * x(i);
                otherwise
                    % Default choice: another function
                    y(i) = sin(2 * pi * x(i)); % Example of another choice
            end
        else
            % Set y(i) to 0 if |x(i)| > 0.5
            y(i) = 0;
        end
    end
end