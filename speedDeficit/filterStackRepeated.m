% Filter and stack repeated entries of data
%   Called in script SOLN_build_data_with_plot

function all_entries_averaged = filterStackRepeated(all_entries)

% % Filter success only -- filtering disabled
% all_entries_averaged = all_entries([all_entries.success]);

all_entries_averaged = all_entries;

% Stack
% Rename variables
for i = 1:length(all_entries_averaged)
    all_entries_averaged(i).success_count = 1;
    all_entries_averaged(i).speed_total = all_entries_averaged(i).speed;
end
i = 1;
while i < length(all_entries_averaged)
    j = i + 1;
    % Check if next entry has same parameters
    if all_entries_averaged(i).theta_ign == ...
            all_entries_averaged(j).theta_ign && ...
            all_entries_averaged(i).t_r == ...
            all_entries_averaged(j).t_r && ...
            all_entries_averaged(i).Y == ...
            all_entries_averaged(j).Y && ...
            strcmpi(all_entries_averaged(i).geometry, ...
            all_entries_averaged(j).geometry)
        % Collapse
        all_entries_averaged(i).success_count = ...
            all_entries_averaged(i).success_count + ...
            all_entries_averaged(j).success_count;
        all_entries_averaged(i).speed_total = ...
            all_entries_averaged(i).speed_total + ...
            all_entries_averaged(j).speed_total;
        % Remove j-th entry
        all_entries_averaged(j) = [];
    else
        i = i + 1;
    end
end
% Calculate average speed
for i = 1:length(all_entries_averaged)
    all_entries_averaged(i).speed_avg = ...
        all_entries_averaged(i).speed_total ./ ...
        all_entries_averaged(i).success_count;
end