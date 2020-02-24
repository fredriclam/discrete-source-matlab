% Objective function for optimization: L2 error (compared with zero fn)
% on unit circle, averaged in t from 0 to 1

function e = objective_function(u, x_source, y_source, ...
    plus_sources, minus_sources)
% Penalty parameters
nu = 0; % Power
alpha = 50; % Constant coefficient
% Penalty term
e_penalty = 0;
for i = 1:length(u)/2
    % Apply penalty if inside disk
    if 1-u(2*i-1)^2-u(2*i)^2 > 0
        e_penalty = e_penalty + (1-u(2*i-1)^2-u(2*i)^2)^nu*alpha;
    end
end

% Error computation
dt = 0.05;
t_interval = dt:dt:1;
e_computed = 0;
for t = t_interval
    fixed_particle = @(x,y) heatResponse_0(0, [x y], ...
        [x_source y_source], t, 0);
    moving_particle = @(x,y,x0,y0) heatResponse_0(0, [x y], [x0 y0], t, 0);
    e_computed = e_computed + ...
        dt * error_on_boundary_polar( ...
            @(x,y) particle_sum(x,y, fixed_particle, moving_particle, u, ...
            plus_sources, minus_sources));
end

e = e_computed + e_penalty;