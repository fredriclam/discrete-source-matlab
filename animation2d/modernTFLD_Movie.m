% Import TFLD file into contour plot
% Input required:
%     x_res: number of grid points in propagation direction
%     y_res: number of grid points in y-direction
%     t_res: (can use automatic version) number of frames captured
%     width_x: physical length in propagation direction
%     width_y: physical width in y
%     file_name_approx: approximate name of the TFLD file
%     caxis_limits: limits of the contour value axis
%     contour_res: step resolution of isocontours for the contourf function

%% Loading
% Load into Z1, Z2, Z3, Z4

% Search for TFLD file specified name
file_name_approx = 'TFLD*';
D = dir(file_name_approx);
file_name_tfld = D(1).name;
file_name_soln = ['SOLN' file_name_tfld(5:end)];
% Input data format parameters
x_res = 200+1; %800+1; % Make sure to plus one!
y_res = 200;
% t_res = 3;%+1; % Or use auto t_res below
% Input problem parameters
width_x = 50;
width_y = 50;
% Config
caxis_limits = [0, 1.5];
contour_res = 0.05; % Step resolution of contour map
% Import data
data = importdata(file_name_tfld);
% Auto t_res
t_res = length(data)/x_res/y_res;
% Reshape the data into paged matrix; access by Z(m,n,T)
Z_4 = reshape(data, [x_res,y_res,t_res]);

% Pre-allocate vectors
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);
%%
% Grab solution cloud

D = importdata('SOLN99_5303437.dat');
x = D.data(:,2);
y = D.data(:,3);
t_i = D.data(:,4);

%%
% Generate right-propagating contour plots out of each captured frame
% Using this (and above+top section) to plot the 50x50 swimming pool

% Close video writer object if it already exists
try
    close(hayao_miyazaki);
end
% Create video writer object
hayao_miyazaki = VideoWriter('ZMovieOutput2.avi','MPEG-4');
hayao_miyazaki.set('FrameRate', 30);
open(hayao_miyazaki);

set(gcf,'position',[0,100,800,600])
dt = 0.01666666666;
warning(['dt is set to ' num2str(dt)])
for i = 2:t_res%1:t_res
    t = (i-1)*dt;
    contourf(x_vector,y_vector,Z_new(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);

    % Strip axes
    set(gca, 'YTick', [], 'YTickLabel', {})
    set(gca, 'XTick', [], 'XTickLabel', {})
%         set(gca, 'YTick', [0, 49.5], 'YTickLabel', {'0', '50'})

    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    hold on;
    % Format and fix aspect ratio
    adjplot;
    set (gca, 'DataAspectRatio', [1 1 1]);
    
%     % Plot points
    plot(x(t_i <= t),y(t_i <= t),'.','color',[1 0 0],'MarkerSize', 0.01);
    plot(x(t_i > t),y(t_i > t),'.','color',0.15*[1 1 1],'MarkerSize', 0.01);
    
    drawnow;
    writeVideo(hayao_miyazaki, getframe(gcf));
end
close(hayao_miyazaki);

%%
% Generate right-propagating contour plots out of each captured frame
Z_ = {Z1, Z2, Z3, Z4};
for i = 300%1:t_res
    for j = 1:4
        subplot(2,2,j);
        contourf(x_vector,y_vector,Z_{j}(:,:,i)',...
            'LineStyle', 'none', 'LevelStep', contour_res);
        
        % Strip axes
        set(gca, 'YTick', [], 'YTickLabel', {})
        set(gca, 'XTick', [], 'XTickLabel', {})
%         set(gca, 'YTick', [0, 49.5], 'YTickLabel', {'0', '50'})

        % Adjust the plot: set contour stuff
        colormap hot;
        caxis(caxis_limits);
        hold on;
        % Format and fix aspect ratio
        adjplot;
        set (gca, 'DataAspectRatio', [1 1 1]);
    end
end

%% Assembled video

% Close video writer object if it already exists
try
    close(hayao_miyazaki);
end
% Create video writer object
hayao_miyazaki = VideoWriter('ZMovieOutput2.avi','MPEG-4');
hayao_miyazaki.set('FrameRate', 30);
open(hayao_miyazaki);
set(gcf,'Position', [1000, 100, 800, 800])
font_size = 24;

for i = 2:t_res
    subplot(2,2,1);
    contourf(x_vector,y_vector,Z_1(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.1    0.5    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % % Strip axes
    % set(gca, 'YTick', [], 'YTickLabel', {})
    % set(gca, 'XTick', [], 'XTickLabel', {})
    set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        ...'TickLength', [0 0], ...
        'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    set(gca,'LineWidth', 1.5)
    xlabel('{\it \theta}_{ign} = 0.1', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [25, 65 , 1])

    subplot(2,2,2);
    contourf(x_vector,y_vector,Z_2(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.5    0.5    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % % Strip axes
    % set(gca, 'YTick', [], 'YTickLabel', {})
    % set(gca, 'XTick', [], 'XTickLabel', {})
    set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        ...'TickLength', [0 0], ...
        'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    ylabel('{\it \tau}_c = 10', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [64, 20 , 1])
    xlabel('{\it \theta}_{ign} = 0.3', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [25, 65 , 1])

    subplot(2,2,3);
    contourf(x_vector,y_vector,Z_3(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.10    0.1    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % Axes
    set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {0, '', '', '', '', 50}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        ...'TickLength', [0 0], ...
        'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {0, '', '', '', '', 50}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);

    subplot(2,2,4);
    contourf(x_vector,y_vector,Z_4(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.5    0.1    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    % Strip axes
    % set(gca, 'YTick', [], 'YTickLabel', {})
    % set(gca, 'XTick', [], 'XTickLabel', {}) 
    set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        ...'TickLength', [0 0], ...
        'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    ylabel('{\it \tau}_c = 0', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [64, 20 , 1])
    drawnow;
    writeVideo(hayao_miyazaki, getframe(gcf));
end
close(hayao_miyazaki);
disp 'done';

%% Assembled video, zoomed on 50x50
% Import first to Z_1 through Z_4 using fopen, textscan, fclose
% sketch_book.m -> width_x, width_y, x_res, y_res, ...

% Close video writer object if it already exists
try
    close(hayao_miyazaki);
end
% Create video writer object
hayao_miyazaki = VideoWriter('ZMovieOutput2.avi','MPEG-4');
hayao_miyazaki.set('FrameRate', 30);
open(hayao_miyazaki);
set(gcf,'Position', [1000, 100, 800, 800])
font_size = 24;

% Special resolution provision
x_vectorSHORT = linspace(0, width_x, 201);
y_vectorSHORT = linspace(0, width_y*(1-1/200), 200);
x_res = 401;
y_res = 400;
width_x = 100;
width_y = 100;
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

for i = floor(0.1*t_res):t_res
    subplot(2,2,1);
    contourf(x_vector,y_vector,Z_1(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.1    0.5    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    set(gca, 'XTick', 25+[0, 10:10:40 , 50], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        'YTick', 25+[0, 10:10:40 , 50], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    set(gca,'LineWidth', 1.5)
    xlabel('{\it \theta}_{ign} = 0.1', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [50, 90 , 1])
    xlim([25, 75]);
    ylim([25, 75]);
    ax = gca;
    ax.XAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    ax.YAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    
    subplot(2,2,2);
    contourf(x_vectorSHORT,y_vectorSHORT,Z_2(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.5    0.5    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    set(gca, 'XTick', 25+[0, 10:10:40 , 50], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        'YTick', 25+[0, 10:10:40 , 50], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    ylabel('{\it \tau}_c = 10^2', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [89.5, 45 , 1])
    xlabel('{\it \theta}_{ign} = 0.3', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [50, 90 , 1])
    xlim([25, 75]);
    ylim([25, 75]);
    ax = gca;
    ax.XAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    ax.YAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    
    subplot(2,2,3);
    contourf(x_vector,y_vector,Z_3(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.10    0.1    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % Axes
    set(gca, 'XTick', 25+[0, 10:10:40 , 50], 'XTickLabel', {0, '', '', '', '', 50}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        'YTick', 25+[0, 10:10:40 , 50], 'YTickLabel', {0, '', '', '', '', 50}, 'YMinorTick', 'On')
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    xlim([25, 75]);
    ylim([25, 75]);
    ax = gca;
    ax.XAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    ax.YAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);

    subplot(2,2,4);
    contourf(x_vector,y_vector,Z_4(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'Position', [0.5    0.1    0.32    0.32]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    set(gca, 'XTick', 25+[0, 10:10:40 , 50], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
        'TickDir', 'out', ...
        'TickLength', 2*[0.0100, 0.0250], ...
        'YTick', 25+[0, 10:10:40 , 50], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
    set(gca, 'FontName', 'Times New Roman');
    set(gca,'LineWidth', 1.5)
    set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
    xlim([25, 75]);
    ylim([25, 75]);
    ylabel('{\it \tau}_c = 0', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [86, 45 , 1])
    ax = gca;
    ax.XAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    ax.YAxis.MinorTickValues = setdiff(25:2:75, 25:10:75);
    
    drawnow;
    writeVideo(hayao_miyazaki, getframe(gcf));
end
close(hayao_miyazaki);
disp 'done';

%% Format test
set(gcf,'Position', [1000, 100, 800, 800])
font_size = 24;
    
subplot(2,2,1);
contourf(x_vector,y_vector,Z_new(:,:,50)',...
    'LineStyle', 'none', 'LevelStep', contour_res);
set(gca, 'Position', [0.1    0.5    0.32    0.32]);
set (gca, 'DataAspectRatio', [1 1 1]);
% % Strip axes
% set(gca, 'YTick', [], 'YTickLabel', {})
% set(gca, 'XTick', [], 'XTickLabel', {})
set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
    'TickDir', 'out', ...
    'TickLength', 2*[0.0100, 0.0250], ...
    ...'TickLength', [0 0], ...
    'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
% Adjust the plot: set contour stuff
colormap hot;
caxis(caxis_limits);
set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
set(gca,'LineWidth', 1.5)
xlabel('{\it \theta}_{ign} = 0.1', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [25, 65 , 1])

subplot(2,2,2);
contourf(x_vector,y_vector,Z_new(:,:,100)',...
    'LineStyle', 'none', 'LevelStep', contour_res);
set(gca, 'Position', [0.5    0.5    0.32    0.32]);
set (gca, 'DataAspectRatio', [1 1 1]);
% % Strip axes
% set(gca, 'YTick', [], 'YTickLabel', {})
% set(gca, 'XTick', [], 'XTickLabel', {})
set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
    'TickDir', 'out', ...
    'TickLength', 2*[0.0100, 0.0250], ...
    ...'TickLength', [0 0], ...
    'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
% Adjust the plot: set contour stuff
colormap hot;
caxis(caxis_limits);
set(gca, 'FontName', 'Times New Roman');
set(gca,'LineWidth', 1.5)
set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
ylabel('{\it \tau}_c = 10', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [64, 20 , 1])
xlabel('{\it \theta}_{ign} = 0.3', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [25, 65 , 1])

subplot(2,2,3);
contourf(x_vector,y_vector,Z_new(:,:,150)',...
    'LineStyle', 'none', 'LevelStep', contour_res);
set(gca, 'Position', [0.10    0.1    0.32    0.32]);
set (gca, 'DataAspectRatio', [1 1 1]);
% Axes
set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {0, '', '', '', '', 50}, 'XMinorTick', 'On', ...
    'TickDir', 'out', ...
    'TickLength', 2*[0.0100, 0.0250], ...
    ...'TickLength', [0 0], ...
    'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {0, '', '', '', '', 50}, 'YMinorTick', 'On')
% Adjust the plot: set contour stuff
colormap hot;
caxis(caxis_limits);
set(gca, 'FontName', 'Times New Roman');
set(gca,'LineWidth', 1.5)
set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);

subplot(2,2,4);
contourf(x_vector,y_vector,Z_new(:,:,end)',...
    'LineStyle', 'none', 'LevelStep', contour_res);
set(gca, 'Position', [0.5    0.1    0.32    0.32]);
set (gca, 'DataAspectRatio', [1 1 1]);
% Adjust the plot: set contour stuff
colormap hot;
caxis(caxis_limits);
% Strip axes
% set(gca, 'YTick', [], 'YTickLabel', {})
% set(gca, 'XTick', [], 'XTickLabel', {}) 
set(gca, 'XTick', [0, 10:10:40 , 49.75], 'XTickLabel', {'', '', '', '', '', ''}, 'XMinorTick', 'On', ...
    'TickDir', 'out', ...
    'TickLength', 2*[0.0100, 0.0250], ...
    ...'TickLength', [0 0], ...
    'YTick', [0, 10:10:40 , 49.75], 'YTickLabel', {'', '', '', '', '', ''}, 'YMinorTick', 'On')
set(gca, 'FontName', 'Times New Roman');
set(gca,'LineWidth', 1.5)
set(gca, 'FontName', 'Times New Roman', 'FontSize', font_size);
ylabel('{\it \tau}_c = 0', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [64, 20 , 1])

% for j = 1:4
%     subplot(2,2,j);
%     % Format and fix aspect ratio
%     % adjplot;
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     % Strip axes
%     set(gca, 'YTick', [], 'YTickLabel', {})
%     set(gca, 'XTick', [], 'XTickLabel', {})
%     % Adjust the plot: set contour stuff
%     colormap hot;
%     caxis(caxis_limits);
% end
    
% set(gca, 'XMinorTick', 'On', 'TickDir', 'out', 'TickLength', 2*[0.0100 0.0250])

% ylabel('{\it \tau}_c = 0', 'FontName', 'Times New Roman', 'Rotation', 0, 'Position', [64, 20 , 1])