% Average volume of sphere in bar stock
function average_vol_fraction = vol_averaged(condition_string, h_bar, ...
    w_bar, r_sphere_influence)
% Resolution of integral
INTEG_RES = 50;

if strcmpi(condition_string, 'bar')
    % Evaluates to true elementwise when inside slab
    in_bar_condition = @(y,z) (abs(y) < w_bar/2) & (abs(z) < h_bar/2);
    condition = in_bar_condition;
    % Parameters
    y_vector = linspace(0,w_bar/2,INTEG_RES);
    z_vector = linspace(0,h_bar/2,INTEG_RES);
    % Weight function
    weight = @(y,z) 1;
    factor = length(y_vector) * length(z_vector);
elseif strcmpi(condition_string, 'slab')
    % Evaluates to true elementwise when inside slab
    in_slab_condition = @(y,z) (abs(z) < h_bar/2);
    condition = in_slab_condition;
    % Parameters
    y_vector = 0;
    z_vector = linspace(0,h_bar/2,INTEG_RES);
    weight = @(y,z) 1;
    % Normalization factor
    factor = length(z_vector);
elseif strcmpi (condition_string, 'cylinder') || ...
        strcmpi (condition_string, 'cyl')
    % Evaluates to true elementwise when inside slab
    in_cyl_condition = @(y,z) y.^2 + z.^2 < (h_bar/2).^2;
    condition = in_cyl_condition;
    % Parameters
    y_vector = 0;
    z_vector = linspace(0,h_bar/2,INTEG_RES);
    weight = @(y,z) sqrt(y.^2 + z.^2);
    factor = h_bar /4 * length(z_vector) ; % !!!! "GUESSED"
else
    error('Unknown condition')
end

% Integrate "forward volume"
integ_sum = 0;
for y = y_vector
    for z = z_vector
        integ_sum = integ_sum + ...
            weight(y,z) * mc_vol(y,z,r_sphere_influence,condition);
    end
end

average_vol_fraction = integ_sum / factor;


% Monte Carlo internal volume evaluation
function vol_fraction = mc_vol(y_centre, z_centre, r_max,...
    condition)

% Generate points
MC_SIZE = 50;
theta_vector = 2*pi*rand(MC_SIZE,1);
phi_vector = acos(2*rand(MC_SIZE,1)-1);
r_vector = r_max*power(rand(MC_SIZE,1),1/3);

% Sphere point picking using r^(1/3) vector
y_vector = r_vector .* sin(phi_vector) .* sin(theta_vector) + y_centre;
z_vector = r_vector .* cos(phi_vector) + z_centre;

% Evaluate the condition supplied
condition_vector = condition(y_vector, z_vector);
% Reduce to volume fraction
vol_fraction = sum(condition_vector)/length(condition_vector);