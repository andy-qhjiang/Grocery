% this is a MATLAB function to create a tessellation pattern based on a given number of divisions (N), length (L), and angle (theta).
% It generates a grid of quadrilateral faces and plots them, while also
% storing the vertices and the interesting mapping: (i,j,k) -> vertex index 
% where (i,j) is the face index and k is the vertex index within that face.

% The layout of quadrilaterals based on the indices (i,j) looks like this:

% (1,n)... (i,n), (i+1,n)... (2*N, 2*N) 
%  .
%  .
%  .
% (1,2)... (i,2), (i+1,2)... (2*N, 2)
% (1,1)... (i,1), (i+1,1)... (2*N, 1)

% and (1,1) is the bottom left corner of the first quadrilateral.


function [vertices, mapping] = make_tessellation(N, L, theta)

    % Compute t1 and t2
    tan_half_theta = tan(theta / 2);
    t1 = (1/(2*N)) * (tan_half_theta / (1 + tan_half_theta));
    
    
    % Function to compute vertex coordinates for face (i,j)
    function [p, q] = get_face_coords(i, j, N, t1)
        if mod(i + j, 2) == 0  % Even i+j
            p = [(i-1)/(2*N), i/(2*N) - t1, i/(2*N), (i-1)/(2*N) + t1];
            q = [(j-1)/(2*N) + t1, (j-1)/(2*N), j/(2*N) - t1, j/(2*N)];
        else                   % Odd i+j
            p = [(i-1)/(2*N) + t1, i/(2*N), i/(2*N) - t1, (i-1)/(2*N)];
            q = [(j-1)/(2*N), (j-1)/(2*N) + t1, j/(2*N), j/(2*N) - t1];
        end
    end      % Initialize vertices and mapping
    vertices = [];  % Will store [p, q] coordinates
    mapping = cell(2*N, 2*N, 4);  % Mapping from (i,j,k) to vertex index
    tolerance = 1e-6;  % Tolerance for coordinate comparison
    
    % First, build the vertices and mapping without plotting
    for i = 1:2*N
        for j = 1:2*N
            [p, q] = get_face_coords(i, j, N, t1);
            face_vertices = zeros(4, 1);  % To store indices for this face
            for k = 1:4
                pk = p(k);
                qk = q(k);
                % Check if this vertex is already in vertices
                found = false;
                for v = 1:size(vertices, 1)
                    if abs(vertices(v,1) - pk) < tolerance && abs(vertices(v,2) - qk) < tolerance
                        face_vertices(k) = v;
                        found = true;
                        break;
                    end
                end
                if ~found
                    % Add new vertex
                    vertices = [vertices; pk, qk];
                    face_vertices(k) = size(vertices, 1);
                end
                % Store mapping
                mapping{i,j,k} = face_vertices(k);
            end
        end
    end
    
    % Scale the vertices by L
    vertices = vertices * L;
      % Plot the tessellation using the shared plotting function
    plot_options = struct(...
        'title', ['Tessellation Pattern with N=', num2str(N), ', \theta=', num2str(theta)], ...
        'showIds', true, ...
        'lineColor', 'b', ...
        'showVertices', true);
    
    % Plot in a new figure (fig_number not specified)
    plot_tessellation(vertices, mapping, N, plot_options);    % Display number of unique vertices
    disp(['Number of unique vertices: ', num2str(size(vertices, 1))]);
end