% Propagate in x-direction, in a cylinder
function [flag, sites_xyz] = run_scm(A, L, r, ratio, mode)

flag = false;

if strcmpi(mode, 'cylinder')
    % Compute number of spheres
    vol_cylinder = (pi*A^2*L);
    vol_sphere = 4/3*pi*r^3;
    N = floor(ratio*vol_cylinder/vol_sphere);
    % Generate geometry
    sites_xyz = generate_cylinder(A, L, N);
elseif strcmpi(mode, 'slab')
    % Compute number of spheres (thickness A in z-dir)
    vol_slab = A*L*L;
    vol_sphere = 4/3*pi*r^3;
    N = floor(ratio*vol_slab/vol_sphere);
    % Generate geometry
    sites_xyz = generate_slab(A, L, N);
else
    error('Invalid geometry')
end

% Search for top, start with spheres touching x = 0 plane
for i = 1:N
    if sites_xyz(1,i) < r
        flag = see_end(sites_xyz,i,N,r,L);
        if flag == true
            break
        end
    end
end

% Cleanup
clear run_scm

function flag = see_end(sites_xyz,i,N,r,L)
% Persistent array of visited sphere indices
persistent visited
if isempty(visited)
    visited = zeros(1,N);
end

% Set flag to false
flag = false;
% Set visited
visited(i) = true;

% Source sphere position
x0 = sites_xyz(1,i);
% Check if end is in range
if x0 > L - r
    flag = true;
    return
end
y0 = sites_xyz(2,i);
z0 = sites_xyz(3,i);

% Look at all possible next candidates
j = i+1;
while j <= N && sites_xyz(1,j) - x0 < 2 * r
    % Visit if not visited
    if ~visited(j)
        % Candidate sphere position
        x = sites_xyz(1,j);
        y = sites_xyz(2,j);
        z = sites_xyz(3,j);
        % Compute centre-to-centre distance, squared
        dist2 = (x-x0)*(x-x0) + (y-y0)*(y-y0) + (z-z0)*(z-z0);
        % If has overlap with sphere j:
        if dist2 < (2*r)*(2*r)
            % Recursive call
            flag = see_end(sites_xyz,j,N,r,L);
            if flag
                break
            end
        end
    end
    % Increment j
    j = j + 1;
end

% Scenario Generation
function sites_xyz = generate_cylinder(A, L, N)
% Random number generation
rng('shuffle');
rand();
% Sphere sites (centre)
sites_x = zeros(1,N);
sites_y = zeros(1,N);
sites_z = zeros(1,N);
% Generate coordinates
for i = 1:N
    % Note: open (0,1)
    sites_x(i) = L*rand();
    % Initial guess for y and z
    y = -A+2*A*rand();
    z = -A+2*A*rand();
    % Reroll until inside cylinder
    while y*y + z*z > A*A
        y = -A+2*A*rand();
        z = -A+2*A*rand();
    end
    sites_y(i) = y;
    sites_z(i) = z;
end
% Compile matrix of position column vectors
sites_xyz = [sites_x; sites_y; sites_z];
% Sort position vectors by x (dictionary sort)
sites_xyz = (sortrows(sites_xyz'))';

% Scenario Generation
function sites_xyz = generate_slab(A, L, N)
% Random number generation
rng('shuffle');
rand();
% Sphere sites (centre)
sites_x = zeros(1,N);
sites_y = zeros(1,N);
sites_z = zeros(1,N);
% Generate coordinates
for i = 1:N
    % Note: open (0,1)
    sites_x(i) = L*rand();
    sites_y(i) = L*rand();
    sites_z(i) = A*rand();
end
% Compile matrix of position column vectors
sites_xyz = [sites_x; sites_y; sites_z];
% Sort position vectors by x (dictionary sort)
sites_xyz = (sortrows(sites_xyz'))';