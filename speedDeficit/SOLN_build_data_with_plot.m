% Call loadSOLN to load all information to a struct-array, with plotting.
% Legacy version.

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
subplot(1,2,1); %
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
title 'Slab: \theta_{ign} = 0.2, \tau_c = 10'
subplot(1,2,2); %
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
title 'Cylinder: \theta_{ign} = 0.2, \tau_c = 10'
%% Breaker
error('Work finished. Plotting ensues')

%% Plotting
active_slab = SOLN_slab_split_1_200;
active_cyl = SOLN_cyl_split_1_200;
% Assuming one parameter-point
figure(120);
subplot(1,2,1); %
Z_slab = [active_slab.Z];
speed_slab = [active_slab.speed];
plot(Z_slab([active_slab.success]), ...
    speed_slab([active_slab.success]),'.');
hold on
plot(Z_slab(~[active_slab.success]), ...
    zeros(size(Z_slab(~[active_slab.success]))),'x')
xlabel 'Thickness'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);
title 'Slab: \theta_{ign} = 0.2, \tau_c = 10'
subplot(1,2,2); %
Z_cyl = [active_cyl.Z];
speed_cyl = [active_cyl.speed];
plot(Z_cyl([active_cyl.success]), ...
    speed_cyl([active_cyl.success]),'.');
hold on
plot(Z_cyl(~[active_cyl.success]), ...
    zeros(size(Z_cyl(~[active_cyl.success]))),'x')
xlabel 'Diameter'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);
title 'Cylinder: \theta_{ign} = 0.2, \tau_c = 10'
