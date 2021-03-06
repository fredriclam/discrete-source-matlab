function all_entries_averaged = filterStackRepeatedManual(all_entries)

% % Filter success only -- filtering disabled
% all_entries_averaged = all_entries([all_entries.success]);

all_entries_averaged = all_entries;

% Stack
% Rename variables
for i = 1:length(all_entries_averaged)
    all_entries_averaged(i).success_count = all_entries_averaged(i).success;
    all_entries_averaged(i).run_count = 1;
    all_entries_averaged(i).r2_min = all_entries_averaged(i).r2;
    
    % Condition speed
    if isnan(all_entries_averaged(i).speed) || ...
            isinf(all_entries_averaged(i).speed)
        all_entries_averaged(i).speed_total = 0;
    else
        all_entries_averaged(i).speed_total = ...
            all_entries_averaged(i).speed * ...
            all_entries_averaged(i).success;
    end
end
i = 1;
while i < length(all_entries_averaged)
    j = i + 1;
    % Check next entry for discard condition (likely failure to initiate)
    rd = all_entries_averaged(j).raw_data;
    if length(rd(rd(:,5) > 0 & rd(:,5) < 1e8)) / length(rd) < 0.10
        % Remove j-th entry
        all_entries_averaged(j) = [];
        continue
    end
    % Check if next entry has same parameters
    if all_entries_averaged(i).theta_ign == ...
            all_entries_averaged(j).theta_ign && ...
            all_entries_averaged(i).t_r == ...
            all_entries_averaged(j).t_r && ...
            all_entries_averaged(i).Y == ...
            all_entries_averaged(j).Y && ...
            all_entries_averaged(i).images == ...
            all_entries_averaged(j).images && ...
            strcmpi(all_entries_averaged(i).geometry, ...
            all_entries_averaged(j).geometry)
        % Collapse
        all_entries_averaged(i).success_count = ...
            all_entries_averaged(i).success_count + ...
            all_entries_averaged(j).success_count;
        all_entries_averaged(i).speed_total = ...
            all_entries_averaged(i).speed_total + ...
            all_entries_averaged(j).speed_total;
        all_entries_averaged(i).run_count = ...
            all_entries_averaged(i).run_count + ...
            all_entries_averaged(j).run_count;
        
        % Get min r2
        if all_entries_averaged(j).r2 < all_entries_averaged(i).r2
            all_entries_averaged(i).r2_min = ...
                all_entries_averaged(j).r2;
        end
        % Remove j-th entry
        all_entries_averaged(j) = [];
    else
        i = i + 1;
    end
end
% Calculate average speed, propagation_probability
for i = 1:length(all_entries_averaged)
    all_entries_averaged(i).speed_avg = ...
        all_entries_averaged(i).speed_total ./ ...
        all_entries_averaged(i).success_count;
    all_entries_averaged(i).propagation_probability = ...
        all_entries_averaged(i).success_count ./ ...
        all_entries_averaged(i).run_count;
end
% Remove extraneous fields
all_entries_averaged = rmfield(all_entries_averaged, {'date', ...
    'success', 'speed_total', ...
    'plot','speed','r2'});