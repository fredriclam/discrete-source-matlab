% Generate <Poster Fig>
% Requires data variable Q = Q64patch

global_line_width = 2;

% Case selection
sel = [10 ,32, 42, 52, 63]-(1)*[2 1 1 1, 1];
% sel = [12 ,32, 42, 52, 63];
line_style = {'-','-','-','-','-'};
% line_style = {'-',':','--','-.','-'};
color_style = {...
    [237 177 32]/255,...
    ...[0 0 0],...
    [191 0 191]/255,...
    [0 114 189]/255,...
    [0 127 0]/255,...
    ...[237 177 32]/255,...
    [162 171 229]/255};

% Data path
Q = Q64patch;

% Prepare
figure(1);clf;
legend_labels = {};


%% W-t plot
% Add W-t plots
for i = 1:length(sel)
    % Pull data
    t = Q(sel(i)).t;
    W = Q(sel(i)).W;
    % Plot W-t curve
    plot(t,W,...
        'Color',color_style{i},...
        'LineWidth', 3,...
        'LineStyle', line_style{i});
    % Hold plot
    if i == 1
        hold on
    end
    % Print label for legend
    legend_labels{i} = [...
        ...'{\it\theta}_{ign} = ' num2str(Q(sel(i)).tign) '; ' ...
        '{\it\tau}_c = ' num2str(Q(sel(i)).tauc)];
end
% Set axes
set(gca, 'ylim', [0, 5]);
xlim([0 120])
adjplot('\itt','\itW',[7, 6],1);

% Ticks
set(gca, ...
    'tickdir','out',...
    'LineWidth', 1.8,...
    'TickLength',0.012*[1, 0.25],...
    ...'XTick', [0, 30, 60, 90, 120],...
    ...'YTick', [0, 2, 4, 6],...
    'FontSize', 25);

% % Add milestone markers (N = x%)
% for i = 1:length(sel)
%     % Pull data
%     t = Q(sel(i)).t;
%     W = Q(sel(i)).W;
%     N = Q(sel(i)).N;
%     % Milestone index msi
%     msi = find(N>4000,1); % 10%
%     plot(t(msi),W(msi),'ok', 'MarkerSize', 10);
%     msi = find(N>20000,1); % 50%
%     plot(t(msi),W(msi),'ok', 'MarkerSize', 16);
% end

% Legend
legend(legend_labels,...
    'Location','NorthEast',...
    'EdgeColor',[1 1 1],...
    'FontSize',16);

%% % Inset generation
% inset_axes = axes('Position',[.46 .545 .395 .33]);
% % inset_axes = axes('Position',[.47 .22 .395 .33]);
% box on
% Loglogs
for i = 1:length(sel)
    t = Q(sel(i)).t;
    W = Q(sel(i)).W;
    N = Q(sel(i)).N;
    
    plot(t,W,...
        'Color',color_style{i},...
        'LineWidth', 2,...
        'LineStyle', line_style{i});
    if i == 1
        hold on
    end
end

set(gca,...
        'XScale','log',...
        'YScale','log');
% Ref Line
platform = 0.79;
ref_line_x = [1e-1, 1e3];
ref_line_y = platform*(ref_line_x).^(1/3)./(ref_line_x(1)).^(1/3);
plot(ref_line_x, ref_line_y, 'k',...
    'LineWidth', 1.5)
% Slope Ramp
x = [2,7.5,7.5];
elevation = platform*(x(1)).^(1/3)./(ref_line_x(1)).^(1/3);
y = elevation*[1, 1, x(3)^(1/3)/x(1)^(1/3)];
% plot(x,y,'k','LineWidth',1.5)
% Slope Ramp Marker
% x_marker = [2^(2/3)*7.5^(1/3)*1.15, 2^(1/3)*7.5^(2/3)*1.1];
% y_marker = [elevation, elevation+0.05];
% plot([x_marker(1) x_marker(1)], y_marker,'k','LineWidth',1.5);
% plot([x_marker(2) x_marker(2)], y_marker,'k','LineWidth',1.5);

% Axis
axis ([0.1, 1000, 0.1, 10]);
adjplot('','');
set(gca,'FontSize',16)
set(gca, ...
    'tickdir','in',...
    'LineWidth', 1.8,...
    'TickLength',0.6*[0.02,0.005]);

% Label names
% adjplot('log_{10} \itt','log_{10} \itW',[3, 3],1);