% Deprecated hack script for 3-D scaling limits analysis.
% Scans all 'PROP*' files in current folder

% Define "go" as
go_threshold = 0.90;

% Get data
D = dir('PROP*');
% Create output stack
clear output_stack;
for i = 1:length(D)
    % Grab data
    dat = importdata(D(i).name);
    % If data came in a struct, separate data and textdata
    if isstruct(dat)
        param = dat.textdata;
        dat = dat.data;
    else
        param = [];
    end
    
    if isempty(dat)
        continue;
    end
    
    % Get TIGN
    str = D(i).name;
    T_ign = 0.001*str2double(str(5:regexp(str,'OD')-1));
    OD = str2double(str(regexp(str,'OD')+2));
    type = str(regexp(str,'OD')+3);
    % Process
    [prim_dimension, percent_propagated] = ...
        binarize_data(dat, go_threshold);
    [critical_dimension, ci, characteristic_scale] = ...
        normal_analysis(prim_dimension, percent_propagated);
    % Generate output item
    item = [];
    item.T_ign = T_ign;
    item.OD = OD;
    item.type = type;
    item.dim_c = critical_dimension;
    item.low_c = ci(1);
    item.high_c = ci(2);
    item.scale = characteristic_scale;
    item.prim_dimension = prim_dimension;
    item.percent_propagated = percent_propagated;
    item.param = param;
    item.plot = @() plot(prim_dimension, percent_propagated);
    % Add to output stack
    output_stack(i) = item;
end

% Sort stack
[~,index] = sortrows([output_stack.T_ign].');
output_stack = output_stack(index);
clear index

% Bind plots
global_plot = @() plot([output_stack.T_ign], [output_stack.dim_c]);

%% Save stack
stack_s = output_stack;
% stack_c = output_stack;

%% Fan plots
for i = 1:length(output_stack)
figure(i)
output_stack(i).plot()
end

%% Calculate ratio ** Rewrite this garbage
% Given stack_c, stack_s
% Extract results from stack_c (cylinder)
results_matrix = [[stack_c.T_ign]',[stack_c.dim_c]'];
% Map from stack_s (slab results)
for j = 1:length(stack_s)
    write_index = find(results_matrix==stack_s(j).T_ign);
    if ~isempty(write_index)
        results_matrix(write_index,3) = stack_s(j).dim_c;
    end
end

i = 1;
while i <= size(results_matrix,1)
    if results_matrix(i,3) ~= 0
        results_matrix (i,4) = results_matrix(i,2)/...
            results_matrix(i,3);
        i = i + 1;
    else
        results_matrix(i,:) = [];
    end
end

figure(203)
plot(results_matrix(:,1), results_matrix(:,4));
ylim([0,5])
xlim([0,0.5])
xlabel ('\theta_{ign}')
ylabel ('d_c / t_c')

figure(202)
clf
plot(results_matrix(:,1), results_matrix(:,2),...
    'r');
hold on
plot(results_matrix(:,1), results_matrix(:,3),...
    'b');
ylim([0,16])
xlim([0,0.5])
xlabel ('\theta_{ign}')
ylabel ('\xi_{cr}')