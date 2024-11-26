function y = initial_fun(x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    y = zeros(1, length(x));
    for i = 1: length(x)
        if abs(x(i)) <=0.5
            % y(i) = cos(pi* x(i))^2;
            y(i) = 1- 2*sign(x(i))*x(i);
        end
    end

   y(abs(y) < 1e-8) = 0; 
  
end