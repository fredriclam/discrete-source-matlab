% Set "active" variable to an array of structs, obtained from
% PROP_build_data and sorted so that only one case (tau_c, theta_ign) with
% one geometry is covered. Generates variable "entry" that can be
% concatenated with data bundles

active = slab_split_50_100;
clear entry;

% Generate entry (struct)
entry.geometry = active(1).geometry;
entry.tau_c = active(1).tau_c;
entry.theta_ign = active(1).theta_ign;
entry.nominal_dimension = NaN; % N/A
entry.dt = active(1).dt;
entry.t_timeout = active(1).t_timeout;
entry.num_images = active(1).num_images;
entry.table_resolution = active(1).table_resolution;
entry.ignite_ratio = active(1).ignite_ratio;
entry.initiation_density_factor = active(1).initiation_density_factor;
entry.ensemble_size = 20; % Compressed data
entry.spread_radius = active(1).spread_radius;
entry.aspect_ratio = active(1).aspect_ratio;
entry.spread_factor = active(1).spread_factor;
entry.progress_percentage = NaN; % N/A
entry.propagation_probability = [active.propagation_probability];
entry.xi = [active.xi];

% Analysis
[model, gof] = erf_fit(entry.xi, entry.propagation_probability);
entry.critical_dimension = model.c;
entry.characteristic_scale = model.a;
ci = confint(model);
entry.ci_lower = ci(1,2);
entry.ci_upper = ci(2,2);
entry.ci = [entry.ci_lower, entry.ci_upper];
entry.plot = @() plot(entry.xi, entry.propagation_probability);

% 
disp('Done')