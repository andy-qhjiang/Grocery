function fig = plot_tessellation(vertices, mapping, N, varargin)
% PLOT_TESSELLATION Plots a tessellation pattern with vertex identification
%
%   fig = plot_tessellation(vertices, mapping, N)
%   fig = plot_tessellation(vertices, mapping, N, options)
%   fig = plot_tessellation(vertices, mapping, N, fig_number, options)
%
%   Inputs:
%       vertices   - Nx2 matrix of vertex coordinates (actual, not normalized)
%       mapping    - Cell array mapping (i,j,k) to vertex index
%       N          - Number of divisions
%       fig_number - (Optional) Figure number to plot in (default: creates new figure)
%       options    - (Optional) Struct with optional parameters:
%           .title      - Title for the plot (default: 'Tessellation Pattern')
%           .showIds    - Whether to enable vertex ID display (default: true)
%           .fillColor  - Color to fill faces (default: [] - no fill)
%           .lineColor  - Color for edges (default: 'b')
%           .lineWidth  - Width for edges (default: 1)
%           .showVertices - Whether to show vertex markers (default: true)
%           .vertexColor - Color for vertex markers (default: 'r')
%           .vertexSize  - Size for vertex markers (default: 30)
%           .axis       - Axis settings struct with .equal, .grid, .xlabel, .ylabel
%
%   Outputs:
%       fig - Figure handle    

    % Default options
    default_options = struct(...
        'title', 'Tessellation Pattern', ...
        'showIds', true, ...
        'fillColor', [], ...
        'lineColor', 'b', ...
        'lineWidth', 1, ...
        'showVertices', true, ...
        'vertexColor', 'r', ...
        'vertexSize', 30, ...
        'axis', struct('equal', true, 'grid', true, 'xlabel', 'x', 'ylabel', 'y'));
    
    % Parse variable arguments
    if nargin == 3
        % No fig_number or options provided
        fig_number = [];
        options = default_options;
    elseif nargin == 4
        % One optional argument provided
        if isstruct(varargin{1})
            % It's options
            options = varargin{1};
            fig_number = [];
        else
            % It's fig_number
            fig_number = varargin{1};
            options = default_options;
        end
    else % nargin >= 5
        % Both fig_number and options provided
        fig_number = varargin{1};
        options = varargin{2};
    end
    
    % Fill in missing options with defaults if options was provided
    if ~isequal(options, default_options)
        fields = fieldnames(default_options);
        for i = 1:length(fields)
            if ~isfield(options, fields{i})
                options.(fields{i}) = default_options.(fields{i});
            elseif strcmp(fields{i}, 'axis') && ~isempty(options.axis)
                % Handle axis struct specifically
                axis_fields = fieldnames(default_options.axis);
                for j = 1:length(axis_fields)
                    if ~isfield(options.axis, axis_fields{j})
                        options.axis.(axis_fields{j}) = default_options.axis.(axis_fields{j});
                    end
                end
            end
        end
    end
    
    % Create figure and get current axes
    if isempty(fig_number)
        fig = figure; % Create a new figure
    else
        fig = figure(fig_number); % Use specified figure number
    end
    ax = gca;
    hold on;
    
    % Store vertex data for data cursor
    vertex_data = [];
    
    % Plot all faces
    for i = 1:2*N
        for j = 1:2*N
            face_vertices = zeros(4, 1);  % To store indices for this face
            for k = 1:4
                face_vertices(k) = mapping{i,j,k};
            end
            % Get coordinates for this face
            x = vertices(face_vertices, 1);
            y = vertices(face_vertices, 2);
            
            % Plot the quadrilateral
            if ~isempty(options.fillColor)
                fill(x, y, options.fillColor, 'LineWidth', options.lineWidth, 'EdgeColor', options.lineColor);
            else
                plot([x; x(1)], [y; y(1)], 'Color', options.lineColor, 'LineWidth', options.lineWidth);
            end
            
            % Plot vertices with markers if enabled
            if options.showVertices
                for k = 1:4
                    v_idx = face_vertices(k);
                    % Only plot a marker if this vertex wasn't already plotted
                    if ~isempty(vertex_data) && any(vertex_data(:,1) == v_idx)
                        continue;
                    end
                    scatter(vertices(v_idx,1), vertices(v_idx,2), options.vertexSize, options.vertexColor, 'filled');
                    % Add to vertex_data: [vertex_id, x, y]
                    vertex_data = [vertex_data; v_idx, vertices(v_idx,1), vertices(v_idx,2)];
                end
            end
        end
    end
    
    % Set up vertex ID display if enabled
    if options.showIds
        % Store vertex data in the axes for the data cursor to access
        setappdata(ax, 'AssetData', struct('Vertex', vertex_data));
        
        % Set custom data tip function
        dcm = datacursormode(fig);
        set(dcm, 'UpdateFcn', @ID_display);
        datacursormode on;
    end
    
    % Set axis properties
    if options.axis.equal
        axis equal;
    end
    if options.axis.grid
        grid on;
    end
    
    % Set title and labels
    title(options.title);
    xlabel(options.axis.xlabel);
    ylabel(options.axis.ylabel);
    hold off;
end

function txt = ID_display(~, event_obj)
    % Custom data tip function to display vertex ID and coordinates
    hAxes = get(get(event_obj, 'Target'), 'Parent');
    assetData = getappdata(hAxes, 'AssetData');

    pos = get(event_obj, 'Position');
    id = vertex_search([pos(1), pos(2)], assetData.Vertex);
    
    txt = {['(x,y) : (', num2str(pos(1), '%.4f'), ',', num2str(pos(2), '%.4f'), ')'], ...
           ['Vertex ID: ', int2str(id)]};
end

function id = vertex_search(pos, vertex_data)
    % Find the vertex ID closest to the position pos
    if isempty(vertex_data)
        id = -1;
        return;
    end
    
    % Extract coordinates from vertex_data ([id, x, y])
    coords = vertex_data(:, 2:3);
    
    % Calculate distances from pos to all vertices
    distances = sqrt(sum((coords - repmat(pos, size(coords, 1), 1)).^2, 2));
    
    % Find the index of minimum distance
    [~, min_idx] = min(distances);
    
    % Return the corresponding vertex ID
    id = vertex_data(min_idx, 1);
end
