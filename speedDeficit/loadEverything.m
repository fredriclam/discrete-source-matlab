% Call loadSOLN to load all information to a struct-array
%   Draft
D = dir('SOLN*');
all_entries_cyl = [];
all_entries_slab = [];
all_entries = [];
for i = 1:length(D)
    disp(['Loading ' num2str(i) '/' num2str(length(D))]);
    file_str = D(i).name;
    entry = loadSOLN(file_str);
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

%% Sorting
[~,index] = sortrows([all_entries_cyl.Z].');
all_entries_cyl = all_entries_cyl(index); clear index
[~,index] = sortrows([all_entries_slab.Z].');
all_entries_slab = all_entries_slab(index); clear index

%% Filtering and stacking
all_entries_cyl_avg = filterStackRepeated(all_entries_cyl);
all_entries_slab_avg = filterStackRepeated(all_entries_slab);

%% Plotting
% Assuming one parameter-point
figure(120);

subplot(1,2,1);
Z_slab = [all_entries_slab_avg.Z];
speed_slab = [all_entries_slab_avg.speed];
plot(Z_slab([all_entries_slab_avg.success]), ...
    speed_slab([all_entries_slab_avg.success]),'.');
hold on
plot(Z_slab(~[all_entries_slab_avg.success]), ...
    zeros(size(Z_slab(~[all_entries_slab_avg.success]))),'x')
xlabel 'Thickness'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);

subplot(1,2,2);
Z_cyl = [all_entries_cyl_avg.Z];
speed_cyl = [all_entries_cyl_avg.speed];
plot(Z_cyl([all_entries_cyl_avg.success]), ...
    speed_cyl([all_entries_cyl_avg.success]),'.');
hold on
plot(Z_cyl(~[all_entries_cyl_avg.success]), ...
    zeros(size(Z_cyl(~[all_entries_cyl_avg.success]))),'x')
xlabel 'Diameter'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);

%% Label
subplot(1,2,1);
title 'Slab: \theta_{ign} = 0.2, \tau_c = 10'
subplot(1,2,2);
title 'Cylinder: \theta_{ign} = 0.2, \tau_c = 10'