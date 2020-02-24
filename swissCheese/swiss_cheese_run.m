% Swiss_cheese_run (cylinder)
%   Inputs
%     D: sphere diameter
%     xi: diameter of cylinder
%     length: length of cylinder
%     density: sphere centres per unit volume
%   Outputs
%     propagation_success: whether initiation and success zones are
%       connected (boolean)
%     time_of_travel: shortest time to travel from a sphere in the
%       initiation zone to a sphere in the success zone (evaluated using
%       travel time function)
%     coords: coords of sphere centres
%     shortest_path: list of indices of nodes yielding the shortest time of
%       travel
%  See also: integrate3
function [propagation_success, time_of_travel, coords, shortest_path] = ...
    swiss_cheese_run(D, xi, length, density, plot_flag)
if nargin == 4
    plot_flag = false;
elseif nargin ~= 5
    error('Invalid number of input arguments.')
end

% Number of particles -- specified via volume * (density == 1)
N = floor(density*pi/4*xi^2*length);
% Initiation length -- specified via 10% * container length
length_initiation = 0.1*length;
% Success length -- specified via (1 - 10%) * container length
length_success = 0.9*length;

% Function that generates Cartesian coordinates of random points picked in a
% cylinder (z goes from 0 to length)
map_to_cartesian = @(diam,length,data) ...
    [ diam/2 * sqrt(data(:,1)) .* [cos(2*pi*data(:,2))], ...
    diam/2 * sqrt(data(:,1)) .* [sin(2*pi*data(:,2))], ...
    length * data(:,3) ];
generate_coords_cyl = @(diam,length,N) map_to_cartesian(diam, length, ...
    rand(N,3));
% Function that returns travel time as function of distance
travel_time = @(distance) distance;
% Distance function
dist = @(p1, p2) norm(p1-p2);

% Generate coordinates
coords = generate_coords_cyl(xi, length, N);
% Sort by z (propagation coordinate)
coords = sortrows(coords,3);

% Adjacency matrix
adj_mat = zeros(N+2,N+2);

% Build list of entries linked to node 1, i.e., the initiation zone
i_fast = 1;
while coords(i_fast,3) < length_initiation
    % Represent edge in adjacency matrix
    adj_mat(i_fast+1,1) = 1;
    adj_mat(1,i_fast+1) = 1;
    % Increment counter
    i_fast = i_fast + 1;
end

% Starting from first particle outside initiation, check for overlap with
% reasonably close previous particles
i_slow = 1;
while i_fast <= N
    % Update event horizon (farthest back in the z-direction to look)
    event_horizon = coords(i_fast,3) - D;
    % Bring slow index up to the event horizon
    while coords(i_slow,3) < event_horizon
        i_slow = i_slow + 1;
    end
    % Check for all possible sphere overlaps
    i = i_slow;
    while i < i_fast
        % Update adjacencies with weights
        pairwise_distance = dist(coords(i,:),coords(i_fast,:));
        weight = travel_time(pairwise_distance);
        if pairwise_distance < D
            adj_mat(i+1,i_fast+1) = weight;
            adj_mat(i_fast+1,i+1) = weight;
        end
        i = i + 1;
    end
    % Increment counter
    i_fast = i_fast + 1;
end

% Build list of entries linked to node N+2, i.e., the success zone
i = N;
while coords(i,3) > length_success
    % Represent edge in adjacency matrix
    adj_mat(i+1,N+2) = 1;
    adj_mat(N+2,i+1) = 1;
    % Decrement counter
    i = i - 1;
end

% Write node names
node_names = cell(N+2,1);
for i = 2:N+1; node_names{i} = num2str(i-1); end
node_names{1} = 'Initiation'; node_names{N+2} = 'End';
equivalent_graph = graph(adj_mat, node_names);

% Compute propagation success
propagation_success = ismember(N+2,dfsearch(equivalent_graph,1));
% Compute shortest path and distance
[shortest_path, d] = shortestpath(equivalent_graph,1,N+2);
% Account for weight of edges to initiation/success node
time_of_travel = d-2;

if plot_flag
    % Prepare plotting spheres
    subplot(1,2,1);
    [X,Y,Z] = sphere;
    % Scale
    X = D/2*X; Y = D/2*Y; Z = D/2*Z;
    % Plot all spheres
    for i = 1:N
        surf(X-coords(i,1),Y-coords(i,2),Z-coords(i,3));
        if i == 1
            hold on
        end
    end
    axis equal;
    % Plot graph representation
    subplot(1,2,2);
    plot(equivalent_graph);
    set(gcf,'units','normalized', 'outerposition', [0 0 1 1]);
end