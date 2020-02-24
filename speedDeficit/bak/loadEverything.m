% Call loadSOLN to load all information to a struct-array
D = dir('SOLN*');
all_entries_cyl = [];
all_entries_slab = [];
all_entries = [];
for i = 1:length(D)
    disp(['Loading ' num2str(i)]);
    file_str = D(i).name;
    entry = loadSOLN(file_str);
    if isempty(entry)
        continue
    end
    all_entries = [all_entries entry];
    if strcmpi(entry.geometry, 'slab')
        all_entries_slab = [all_entries_slab entry];
    else
        all_entries_cyl = [all_entries_cyl entry];
    end
end

%% Sorting
[~,index] = sortrows([all_entries_cyl.Y].');
all_entries_cyl = all_entries_cyl(index); clear index
[~,index] = sortrows([all_entries_slab.Y].');
all_entries_slab = all_entries_slab(index); clear index

%% Filtering and stacking
all_entries_cyl_avg = filterStackRepeated(all_entries_cyl);
all_entries_slab_avg = filterStackRepeated(all_entries_slab);

%% Plotting
% Assuming one parameter-point
figure(120);

subplot(1,2,1);
Y_slab = [all_entries_slab_avg.Y];
speed_slab = [all_entries_slab_avg.speed];
plot(Y_slab([all_entries_slab_avg.success]), ...
    speed_slab([all_entries_slab_avg.success]) );
xlabel 'Thickness'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);

subplot(1,2,2);
Y_cyl = [all_entries_cyl_avg.Y];
speed_cyl = [all_entries_cyl_avg.speed];
plot(Y_cyl([all_entries_cyl_avg.success]), ...
    speed_cyl([all_entries_cyl_avg.success]));
xlabel 'Diameter'
ylabel 'Speed'
YL = ylim; ylim([0 YL(2)]);