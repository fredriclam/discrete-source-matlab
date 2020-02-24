% Call loadSOLN to load all information to a struct-array
function [all_entries_cyl_avg, all_entries_slab_avg, ...
    all_entries_cyl, all_entries_slab] ...
    = SOLN_build_data(look_in_subfolders)

if nargin == 0
    look_in_subfolders = false;
end

if look_in_subfolders % Looks only at SOLN in subfolders (1-deep)
    folder = dir;
    name_list = {};
    index = 1;
    for i = 1:length(folder)
        if ~folder(i).isdir || strcmpi(folder(i).name, '.') || ...
                strcmpi (folder(i).name, '..')
            continue
        end
        fname = folder(i).name;
        filenames = dir([fname '\SOLN*']);
        for j = 1:length(filenames)
            name_list{index} = [fname '\' filenames(j).name];
            index = index + 1;
        end
    end
else
    D = dir('SOLN*');
    name_list = {};
    for i = 1:length(D)
        name_list{i} = D(i).name;
    end
end
all_entries_cyl = [];
all_entries_slab = [];
all_entries = [];
for i = 1:length(name_list)
    disp(['Loading ' num2str(i) '/' num2str(length(name_list))]);
    file_str = name_list{i};
    entry = loadSOLN(file_str);
    % Skip entry if nothing loaded
    if isempty(entry)
        continue
    end
    
    if strcmpi(entry.geometry, 'slab')
        entry.Z = entry.Y/10; % Slab: thickness 1/10th of width
        all_entries_slab = [all_entries_slab entry];
    else
        entry.Z = entry.Y; % Cylinder: diameter same in y, z
        all_entries_cyl = [all_entries_cyl entry];
    end
    % Archival
    all_entries = [all_entries entry];
    
end

if isempty(all_entries_cyl) && isempty(all_entries_slab)
    warning('Nothing found.');
end

%% Sorting, filtering and stacking
all_entries_cyl_avg = [];
all_entries_slab_avg = [];
if ~isempty(all_entries_cyl)
    [~,index] = sortrows([all_entries_cyl.Z].');
    all_entries_cyl = all_entries_cyl(index); clear index
    all_entries_cyl_avg = filterStackRepeated(all_entries_cyl);
end

if ~isempty(all_entries_slab)
    [~,index] = sortrows([all_entries_slab.Z].');
    all_entries_slab = all_entries_slab(index); clear index
    all_entries_slab_avg = filterStackRepeated(all_entries_slab);
end

function all_entries_averaged = filterStackRepeated(all_entries)

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
        % Get speed
        all_entries_averaged(i).speed_total = ...
            all_entries_averaged(i).speed_total + ...
            all_entries_averaged(j).speed_total;
        
        
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