% Plot all cases from specified data_set collection

% item_x = @(i) data_set(i).t * flame_switch_speed(data_set(i).tign);
% item_y = @(i) data_set(i).W;
% x_name = '\it{t} \it{u}_f^{continuum}';
% y_name = '\it{W}';

% Safety
assert(~strcmpi(cd,'D:\Data Essentials'));
% Clean up
close all;

% Select data set
data_set = all_data;
% data_set = all_data(9:28);

% Change me! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
item_x = @(i) log(data_set(i).t * flame_switch_speed(data_set(i).tign));
item_y = @(i) log(data_set(i).W);
x_name = 'ln (\it{t} \it{u}_f^{continuum})';
y_name = 'ln \it{W}';

% 1. Stacked plot
figure(666);
for i = 1:length(data_set)
    plot(item_x(i), item_y(i), ...
        'Color',...
        get_rainbow_colour(i,length(data_set)));
    if i == 1
        hold on
    end
end
axis auto;
% Replace x-limit
xlims = get(gca,'XLim');
% xlims(1) = 0;
% set(gca, 'XLim', xlims);
% Check: manual setting for ticks (use if you want an integer on x-axis)
    set(gca, 'XTickMode', 'Manual');
% Replace y-limit
ylims = get(gca,'YLim');
% ylims = [0, 7];
set(gca,'YLim',ylims);
% Tidy up axes fonts
adjplot(x_name,y_name, [5 6], true);
% Get legend
for i = 1:length(data_set)
    labels{i} = ['\tau' num2str(data_set(i).tauc),...
        ':\theta', num2str(data_set(i).tign)];
end
legend(labels, 'Location','EastOutside');
% Save figure
savefig('ALL.fig');
close(666);

% 2. Generate individual plots
for i = 1:length(data_set)
%     fn = @() deal(data_set(i).t, [], [], data_set(i).W);
    plot(item_x(i), item_y(i));
    axis tight;
    % Replace x-limit
%     xlims = get(gca,'XLim');
%     xlims(1) = 0;
    set(gca, 'XLim', xlims);
%     set(gca, 'XTickMode', 'Auto');
    % Replace y-limit
%     ylims = [0, 7];
    set(gca,'YLim',ylims);
    % Tidy up axes fonts
    adjplot(x_name, y_name, [5 6], true); 
    savefig(data_set(i).name);
end

%% View only
% 3. Slideshow

start_index = 9;
end_index = length(fig_list);
fig_list = dir('*.fig');

% Purify list
i = 1;
while i <= length(fig_list)
    if strcmp(fig_list(i).name, 'ALL.fig')
        fig_list(i) = [];
    else
        i = i + 1;
    end
end
close all;
% Load all requested
for i = start_index:end_index
    open(fig_list(i).name);
    % Set window name
    set(gcf, 'Name',...
        ['TAUC' num2str(data_set(i).tauc), ...
        '-TIGN' num2str(data_set(i).tign)]);
    set(gcf,'units','normalized','position',[0.25,-0.25,1,1]);
    drawnow;
end

% 4. Flip through
i = 1;
while 1337
    figure(i);
    pause;
    i = i + 1;
    if i > end_index-start_index+1
        i = 1;
    end
end