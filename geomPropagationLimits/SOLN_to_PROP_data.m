% Converts data structure from SOLN_build_data to an entry compatible with
% PROP_build_data, in order to recover critical thickness or diameter from
% .SOLN files.

% Set me to data structure created from SOLN_build_data
active = all_entries_slab_avg4M3; %change me

% Returns entries in format compatible with PROP_build_data
entries = [];

theta_ign_vector = unique([active.theta_ign]);
tau_c_vector = unique([active.t_r]);

for i = 1:length(theta_ign_vector)
    theta_ign = theta_ign_vector(i);
    for j = 1:length(tau_c_vector)
        tau_c = tau_c_vector(j);
        subset = active(...
            [active.theta_ign] == theta_ign & ...
            [active.t_r] == tau_c);
        if ~isempty(subset)
            % Generate entry
            [model, gof] = erf_fit( ...
                [subset.Z], [subset.propagation_probability],...
                5); % Change me
            entry = subset(1);
            
            % Too small
            if length([subset.Z]) < 3
                continue
            end
            
            % Conversion
            entry.tau_c = tau_c;
            entry.num_images = entry.images;
            entry.table_resolution = entry.table_res;
            entry.initiation_density_factor = []; % unknown (manual)
            entry.ignite_ratio = [];
            entry.ensemble_size = [];
            entry.nominal_dimension = [];
            entry.spread_factor = [];
            entry.spread_radius = [];
            entry.aspect_ratio = [];
            entry.xi = [subset.Z];
            entry.progress_percentage = [];
            entry.propagation_probability = [subset.propagation_probability];
            entry.critical_dimension = model.c;
            ci = confint(model);
            entry.ci = ci(:,2)';
            entry.characteristic_scale = model.a;
            entry.plot = [];
            entry.ci_lower = entry.ci(1);
            entry.ci_upper = entry.ci(2);

            entry = rmfield(entry, {'raw_data', 't_r', ...
                'images', 'table_res', ...
                'X', 'Y', 'Z', ...
                'x_skip', 'x_vector', 't_vector', ...
                'success_count', 'run_count', ...
                'r2_min', 'speed_avg'});
            
            entries = [entries entry];
        end
    end
end