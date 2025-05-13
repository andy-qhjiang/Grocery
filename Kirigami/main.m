%% Main program for Kirigami optimization
% Clear workspace and set parameters
clearvars
N = 3;        % Example N value (can be changed)
L = 2*N;        % Side length of large square
theta = pi/3; % Angle for deployed pattern
target_circle_radius = sqrt(2)*N;
fig_count = 1;

%% Generate initial patterns
% Generate compact pattern: divide [0, L] x [0, L] into 2N x 2N squares
[points0, mapping0] = make_tessellation(N, L, 0);
num_vertices_compact = size(points0, 1);


% Generate deployed pattern
[pointsD, mappingD] = make_tessellation(N, L, theta);
num_vertices_deployed = size(pointsD, 1);

% Center the deployed pattern at the origin
center = mean(pointsD, 1);
pointsD = pointsD - center;

%% Identify boundary points
% Find boundary points of compact pattern
left_ind = find(points0(:,1) == min(points0(:,1)));
right_ind = find(points0(:,1) == max(points0(:,1)));
bottom_ind = find(points0(:,2) == min(points0(:,2)));
top_ind = find(points0(:,2) == max(points0(:,2)));

% Find boundary points of deployed pattern
maxX = max(abs(pointsD(:,1)));
maxY = max(abs(pointsD(:,2)));
boundaryPoints = find(abs(pointsD(:,1)) == maxX | abs(pointsD(:,2)) == maxY);

%% Identify overlap angles
overlap = createOverlapArray(mappingD, N);

%% Set up optimization variables
% Create initial guess by combining compact and deployed vertices
v0 = reshape([points0; pointsD]', [], 1);

% Set up linear constraints for boundary points of compact pattern
[Aeq, beq] = setupLinearConstraints(left_ind, right_ind, bottom_ind, top_ind, length(v0), L);

% Set up nonlinear constraints function
nonlcon = @(v) allNonlinearConstraints(v, mapping0, mappingD, num_vertices_compact, boundaryPoints, N, target_circle_radius, overlap);

%% Run optimization
% Define objective function (minimize the change from initial guess)
objective = @(v) sum((v-v0).^2);

% Set optimization options
options = optimoptions('fmincon', 'Display', 'iter', 'MaxFunctionEvaluations', 30000, ...
                       'OptimalityTolerance', 1e-6, 'ConstraintTolerance', 1e-6);

% No inequality constraints or bounds
A = [];  b = [];  
lb = [zeros(2*num_vertices_compact, 1); -target_circle_radius*ones(2*num_vertices_deployed, 1)];  
ub = [L*ones(2*num_vertices_compact, 1); target_circle_radius*ones(2*num_vertices_deployed, 1)];

% Solve the optimization problem
tic
[v_opt, fval, exitflag, output] = fmincon(objective, v0, A, b, Aeq, beq, lb, ub, nonlcon, options);
toc

%% Process resultsxi
% Extract optimized points
points0_opt = reshape(v_opt(1:2*num_vertices_compact), 2, num_vertices_compact)';
pointsD_opt = reshape(v_opt(2*num_vertices_compact+1:end), 2, num_vertices_deployed)';

% Display results
disp(['Optimization exit flag: ', num2str(exitflag)]);
disp(['Objective function value: ', num2str(fval)]);

%% Visualize results
compact_options = struct(...
        'figNum', 3, ... 
        'title', 'Optimized Compact Pattern', ...
        'showIds', true, ...
        'fillColor', [255 229 204]/255, ...
        'lineWidth', 1.5, ...
        'showVertices', true);
    
plot_tessellation(points0_opt, mapping0, N, compact_options);   % Plot compact pattern in figure 


deployed_options = struct(...
        'figNum', 4, ... 
        'title', 'Optimized Deployed Pattern', ...
        'showIds', true, ...
        'fillColor', [255 229 204]/255, ...
        'lineWidth', 1.5, ...
        'showVertices', true);
plot_tessellation(pointsD_opt, mappingD, N, deployed_options);  % Plot deployed pattern in figure 

graph = figure(4);
hold on
% Add the circle to the deployed pattern subplot
eta = linspace(0, 2*pi, 100);
plot(target_circle_radius*cos(eta), target_circle_radius*sin(eta), 'g-', 'LineWidth', 2);


%% ======== Support Functions ========

function [Aeq, beq] = setupLinearConstraints(left_ind, right_ind, bottom_ind, top_ind, n_vars, L)
    % Create linear equality constraints to fix boundary points of compact pattern
    % We'll fix the compact pattern to stay on the boundary of [0,L]x[0,L] square
    
    % Linear equality constraints: Ax = b
    Aeq = zeros(length([left_ind; right_ind; bottom_ind; top_ind]), n_vars);
    beq = zeros(size(Aeq, 1), 1);

    % Counter for constraint index
    constraint_idx = 0;

    % Fix x-coordinates for left boundary points
    for i = 1:length(left_ind)
        constraint_idx = constraint_idx + 1;
        Aeq(constraint_idx, 2*left_ind(i)-1) = 1;  % x-coordinate
        beq(constraint_idx) = 0;  % x = 0
    end

    % Fix x-coordinates for right boundary points
    for i = 1:length(right_ind)
        constraint_idx = constraint_idx + 1;
        Aeq(constraint_idx, 2*right_ind(i)-1) = 1;  % x-coordinate
        beq(constraint_idx) = L;  % x = L
    end

    % Fix y-coordinates for bottom boundary points
    for i = 1:length(bottom_ind)
        constraint_idx = constraint_idx + 1;
        Aeq(constraint_idx, 2*bottom_ind(i)) = 1;  % y-coordinate
        beq(constraint_idx) = 0;  % y = 0
    end

    % Fix y-coordinates for top boundary points
    for i = 1:length(top_ind)
        constraint_idx = constraint_idx + 1;
        Aeq(constraint_idx, 2*top_ind(i)) = 1;  % y-coordinate
        beq(constraint_idx) = L;  % y = L
    end
end

function [c, ceq] = allNonlinearConstraints(v, mapping1, mapping2, num_vertices_1, boundaryPoints, N, radius, overlap)
    % Combine all nonlinear constraints
    
    % Edge length constraints
    edge_constraints = edgeLengthConstraints(v, mapping1, mapping2, num_vertices_1, N);
    
    % Boundary circle constraints
    circle_constraints = boundaryCircleConstraints(v, boundaryPoints, num_vertices_1, radius);
    
    % Equality constraints
    ceq = [edge_constraints; circle_constraints];
    
    % Non-overlapping inequality constraints
    c = nonOverlapConstraints(v, overlap, num_vertices_1);
end

function overlap_array = createOverlapArray(mappingD, N)
    % Create an array of vertex triplets (x,y,z) where y-x,z-x should have positive outer product
    % to ensure non-overlapping in the deployed pattern
    
    overlap_array = []; % Each row contains [vertex1, vertex2, vertex3]
    
    for i = 1:2*N
        for j = 1:2*N
            % Check if adjacent faces exist (right and up)
            has_right = (i < 2*N);
            has_up = (j < 2*N);
            
            if mod(i + j, 2) == 0  % Even i+j
                % Shared vertex between (i,j) and (i,j+1)
                if has_up
                    % (i,j,4), (i,j+1,4), (i,j,1)
                    v1 = mappingD{i,j,4};
                    v2 = mappingD{i,j+1,4};
                    v3 = mappingD{i,j,1};
                    overlap_array = [overlap_array; v1, v2, v3];
                    
                    % (i,j,4), (i,j,3), (i,j+1,2)
                    v1 = mappingD{i,j,4};
                    v2 = mappingD{i,j,3};
                    v3 = mappingD{i,j+1,2};
                    overlap_array = [overlap_array; v1, v2, v3];
                end
                
                % Shared vertex between (i,j) and (i+1,j)
                if has_right
                    % (i,j,3), (i,j,2), (i+1,j,1)
                    v1 = mappingD{i,j,3};
                    v2 = mappingD{i,j,2};
                    v3 = mappingD{i+1,j,1};
                    overlap_array = [overlap_array; v1, v2, v3];
                    
                    % (i,j,3), (i+1,j,3), (i,j,4)
                    v1 = mappingD{i,j,3};
                    v2 = mappingD{i+1,j,3};
                    v3 = mappingD{i,j,4};
                    overlap_array = [overlap_array; v1, v2, v3];
                end
            else  % Odd i+j
                % Shared vertex between (i,j) and (i,j+1)
                if has_up
                    % (i,j,3), (i,j+1,1), (i,j,4)
                    v1 = mappingD{i,j,3};
                    v2 = mappingD{i,j+1,1};
                    v3 = mappingD{i,j,4};
                    overlap_array = [overlap_array; v1, v2, v3];
                    
                    % (i,j,3), (i,j,2), (i,j+1,3)
                    v1 = mappingD{i,j,3};
                    v2 = mappingD{i,j,2};
                    v3 = mappingD{i,j+1,3};
                    overlap_array = [overlap_array; v1, v2, v3];
                end
                
                % Shared vertex between (i,j) and (i+1,j)
                if has_right
                    % (i,j,2), (i,j,1), (i+1,j,2)
                    v1 = mappingD{i,j,2};
                    v2 = mappingD{i,j,1};
                    v3 = mappingD{i+1,j,2};
                    overlap_array = [overlap_array; v1, v2, v3];
                    
                    % (i,j,2), (i+1,j,4), (i,j,3)
                    v1 = mappingD{i,j,2};
                    v2 = mappingD{i+1,j,4};
                    v3 = mappingD{i,j,3};
                    overlap_array = [overlap_array; v1, v2, v3];
                end
            end
        end
    end
end

function edge_diff_constraints = edgeLengthConstraints(v, mapping1, mapping2, num_vertices_1, N)
    % Compute edge length squared constraints for all faces
    constraints = [];
    
    for i = 1:2*N
        for j = 1:2*N
            for k = 1:4
                % Get next vertex index (wrapping around to 1 if k = 4)
                k_next = mod(k, 4) + 1;
                
                % Get vertex indices for compact pattern
                v1_idx = mapping1{i,j,k};
                v2_idx = mapping1{i,j,k_next};
                
                % Get vertex indices for deployed pattern
                v1_idx_d = mapping2{i,j,k};
                v2_idx_d = mapping2{i,j,k_next};
                
                % Adjust indices for deployed pattern (they come after compact pattern in v)
                v1_idx_d = v1_idx_d + num_vertices_1;
                v2_idx_d = v2_idx_d + num_vertices_1;
                
                % Calculate coordinates from v
                x1 = v(2*v1_idx-1); y1 = v(2*v1_idx);
                x2 = v(2*v2_idx-1); y2 = v(2*v2_idx);
                
                w1 = v(2*v1_idx_d-1); z1 = v(2*v1_idx_d);
                w2 = v(2*v2_idx_d-1); z2 = v(2*v2_idx_d);
                
                % Edge length squared for compact pattern
                edge_length_compact = (x2-x1)^2 + (y2-y1)^2;
                
                % Edge length squared for deployed pattern
                edge_length_deployed = (w2-w1)^2 + (z2-z1)^2;
                
                % Edge length compatibility constraint: they should be equal
                constraints = [constraints; edge_length_compact - edge_length_deployed];
            end
        end
    end
    
    edge_diff_constraints = constraints;
end

function boundary_constraints = boundaryCircleConstraints(v, boundaryPoints, num_vertices_compact, radius)
    % Constrain boundary points to lie on circle w^2 + z^2 = radius^2
    constraints = [];
    
    for i = 1:length(boundaryPoints)
        % Adjust index for deployed pattern (they come after compact pattern in v)
        bp_idx = boundaryPoints(i) + num_vertices_compact;
        
        % Get coordinates
        w = v(2*bp_idx-1);
        z = v(2*bp_idx);
        
        % Circle constraint: w^2 + z^2 = radius^2
        constraints = [constraints; w^2 + z^2 - radius^2];
    end
    
    boundary_constraints = constraints;
end

function c_overlap = nonOverlapConstraints(v, overlap_array, num_vertices_compact)
    % Compute inequality constraints for non-overlapping based on the overlap_array
    % Each constraint ensures that the outer product (y-x)×(z-x) > 0
    % We express this as -((y-x)×(z-x)) < 0 for fmincon

    c_overlap = [];
    epsilon = 1e-6; % Small positive value to ensure strict inequality
    
    for i = 1:size(overlap_array, 1)
        % Get the three vertex indices from the overlap array
        v1_idx = overlap_array(i, 1); % Center vertex x
        v2_idx = overlap_array(i, 2); % y
        v3_idx = overlap_array(i, 3); % z
        
        % Adjust indices for deployed pattern (they come after compact pattern in v)
        v1_idx = v1_idx + num_vertices_compact;
        v2_idx = v2_idx + num_vertices_compact;
        v3_idx = v3_idx + num_vertices_compact;
        
        % Get coordinates from v
        x1 = v(2*v1_idx-1); y1 = v(2*v1_idx);    % Center vertex
        x2 = v(2*v2_idx-1); y2 = v(2*v2_idx);    % Second vertex
        x3 = v(2*v3_idx-1); y3 = v(2*v3_idx);    % Third vertex
        
        % Compute vectors from center
        vec1 = [x2 - x1, y2 - y1]; % vector y-x
        vec2 = [x3 - x1, y3 - y1]; % vector z-x
        
        % Compute 2D cross product (outer product): vec1 × vec2
        cross_product_z = vec1(1)*vec2(2) - vec1(2)*vec2(1);
        
        % Constraint: cross_product_z > 0 (ensure counter-clockwise ordering)
        % For fmincon, express as: -cross_product_z + epsilon <= 0
        c_overlap = [c_overlap; -cross_product_z + epsilon];
    end
end


