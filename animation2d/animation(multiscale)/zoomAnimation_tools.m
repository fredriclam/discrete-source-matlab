window_size = [680 100 960 880];

close all;

% Base scales
xlim1 = [0, 1];
ylim1 = [0, 1];

xlim2 = [0, 6];
ylim2 = [-2.5, 3.5];

xlim3 = [0, 100];
ylim3 = [-49.5, 50.5];

% Linear interpolation
interpolateInterval = @(I1, I2, t) (1-t) * I1 + t * I2;

% Generate test cloud
% blankCloud = [50*rand(2500,1),50*rand(2500,1)];

% Window settings
defaultMarkerSize = 25;
set(gcf,'position',window_size);
% Contour settings
caxis_limits = [0, 1.2];
contour_res = 0.08; % Step resolution of contour map
rectangle_base_color = [0.5, 0.5, 0.5, 1];

%% Video writer
% Close video writer object if it already exists
try
    close(m_night_shamalama);
end
% Create video writer object
m_night_shamalama = VideoWriter('MovieOutput4','MPEG-4');
m_night_shamalama.set('FrameRate', 30);
open(m_night_shamalama);

%% Scale 1 plotting
% Initialize
curr_xlim = xlim1;
curr_ylim = ylim1;
curr_markerSize = defaultMarkerSize;
dt = 6e-5;
for i = 2:2:1000
    time = dt*(i-1);
    contourf(x_vector1,y_vector1,Z1(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on
%     % Plot all points
%     plot(SOLN1(:,2), SOLN1(:,3), '.', 'MarkerSize', ...
%         curr_markerSize, 'Color', 0.8*[1 1 1]);
    % Plot ignited and unignited points
    plot(SOLN1(SOLN1(:,4) <= time, 2), SOLN1(SOLN1(:,4) <= time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 0 0]);
    plot(SOLN1(SOLN1(:,4) > time, 2), SOLN1(SOLN1(:,4) > time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 1 1]);
    hold off;
    % Scale
    xlim(curr_xlim);
    ylim(curr_ylim);
    daspect([1 1 1]); % pbaspect([1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Strip axes
    axis off;
%     set(gca, 'YTick', [], 'YTickLabel', {})
%     set(gca, 'XTick', [], 'XTickLabel', {})
    
%     drawnow;
    % Debug
    writeVideo(m_night_shamalama, getframe(gcf));
end

freeze_frame_1_2 = 7; % intersect(0:6e-5:0.06, 0:0.008:8) and then find in 0:0.008:8

%% Pause
pause_frames = 20;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Fade in scale 1 rectangle
highlighting_frames = 40;
backlash = 0.005;
rect_coordinates = [curr_xlim(1) + backlash, ...
    curr_ylim(1) + backlash, ...
    curr_xlim(2) - curr_xlim(1) - 2 * backlash, ...
    curr_ylim(2) - curr_ylim(1) - 3 * backlash];
rect_handle = rectangle(...
    'Position', rect_coordinates, 'EdgeColor', [0 0 0 ], 'LineWidth', 2);
for i = 1:highlighting_frames
    colorValue = i / highlighting_frames;
     set(rect_handle, 'EdgeColor', colorValue * rectangle_base_color);
     % debug
     writeVideo(m_night_shamalama, getframe(gcf));
end

%% Scale 1 -> 2 transition
transition_frames = 50;
for i = 1:transition_frames
    % Interpolation parameter
    t = i/transition_frames;
    % Current axis limits
    curr_xlim = interpolateInterval(xlim1,xlim2,t);
    curr_ylim = interpolateInterval(ylim1,ylim2,t);

    area = (curr_xlim(2) - curr_xlim(1)) * (curr_ylim(2) - curr_ylim(1));
    curr_markerSize = defaultMarkerSize * sqrt(1 / area);
    
    contourf(x_vector2,y_vector2,Z2(:,:,freeze_frame_1_2)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on;
    % Plot points
    plot(SOLN2(:,2), SOLN2(:,3), '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 1 1]);
    rect_handle = rectangle(...
        'Position', rect_coordinates, 'EdgeColor', ...
        colorValue*rectangle_base_color, ...
        'LineWidth', 2);
    hold off;
    % Scale
    xlim(curr_xlim);
    ylim(curr_ylim);
    daspect([1 1 1]); % pbaspect([1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Strip axes
    axis off;
    
    drawnow;
    % Debug
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Pause
pause_frames = 15;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Fade out scale 1 rectangle
highlighting_frames = 10;
% backlash = 0.005;
% rect_coordinates = [curr_xlim(1) + backlash, ...
%     curr_ylim(1) + backlash, ...
%     curr_xlim(2) - curr_xlim(1) - 2 * backlash, ...
%     curr_ylim(2) - curr_ylim(1) - 2 * backlash];
% rect_handle = rectangle(...
%     'Position', rect_coordinates, 'EdgeColor', [0 0 0 ], 'LineWidth', 2);
for i = 1:highlighting_frames
    colorValue = 1 - i / highlighting_frames;
     set(rect_handle, 'EdgeColor', colorValue * rectangle_base_color);
     % debug
     writeVideo(m_night_shamalama, getframe(gcf));
end

%% Pause
pause_frames = 25;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Scale 2 plotting
% Initialize
curr_xlim = xlim2;
curr_ylim = ylim2;
dt = 0.008;
for i = freeze_frame_1_2:1:151
    time = dt*(i-1);
    contourf(x_vector2,y_vector2,Z2(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on
%     % Plot all points
%     plot(SOLN2(:,2), SOLN2(:,3), '.', 'MarkerSize', ...
%         curr_markerSize, 'Color', 0.8*[1 1 1]);
    % Plot ignited and unignited points
    plot(SOLN2(SOLN2(:,4) <= time, 2), SOLN2(SOLN2(:,4) <= time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 0 0]);
    plot(SOLN2(SOLN2(:,4) > time, 2), SOLN2(SOLN2(:,4) > time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 1 1]);
    hold off;
    % Scale
    xlim(curr_xlim);
    ylim(curr_ylim);
    daspect([1 1 1]); % pbaspect([1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Strip axes
    axis off;
%     set(gca, 'YTick', [], 'YTickLabel', {})
%     set(gca, 'XTick', [], 'XTickLabel', {})
    
    drawnow;
    % Debug
    writeVideo(m_night_shamalama, getframe(gcf));
end

freeze_frame_2_3 = 41; % intersect(0:6e-5:0.06, 0:0.008:8) and then find in 0:0.008:8

%% Pause
pause_frames = 30;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Fade in scale 2 rectangle
highlighting_frames = 20;
backlash = 0.03;
rect_coordinates = [curr_xlim(1) + backlash, ...
    curr_ylim(1) + backlash, ...
    curr_xlim(2) - curr_xlim(1) - 2 * backlash, ...
    curr_ylim(2) - curr_ylim(1) - 3 * backlash];
rect_handle = rectangle(...
    'Position', rect_coordinates, 'EdgeColor', [0 0 0 ], 'LineWidth', 2);
for i = 1:highlighting_frames
    colorValue = i / highlighting_frames;
     set(rect_handle, 'EdgeColor', colorValue * rectangle_base_color);
     % debug
     writeVideo(m_night_shamalama, getframe(gcf));
end

%% Scale 2 -> 3 transition
transition_frames = 120;
for i = 1:transition_frames
    % Interpolation parameter
    t = i/transition_frames;
    % Current axis limits
    curr_xlim = interpolateInterval(xlim2,xlim3,t);
    curr_ylim = interpolateInterval(ylim2,ylim3,t);

    area = (curr_xlim(2) - curr_xlim(1)) * (curr_ylim(2) - curr_ylim(1));
    curr_markerSize = defaultMarkerSize * sqrt(1 / area);
    
    contourf(x_vector3,y_vector3,Z3(:,:,freeze_frame_2_3)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on;
    % Plot points
    plot(SOLN3(:,2), SOLN3(:,3), '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 1 1]);
    rect_handle = rectangle(...
        'Position', rect_coordinates, 'EdgeColor', ...
        colorValue*rectangle_base_color, ...
        'LineWidth', 2);
    hold off;
    % Scale
    xlim(curr_xlim);
    ylim(curr_ylim);
    daspect([1 1 1]); % pbaspect([1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Strip axes
    axis off;
    
    drawnow;
    % Debug
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Pause
pause_frames = 20;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Fade out scale 2 rectangle
highlighting_frames = 20;
% backlash = 0.005;
% rect_coordinates = [curr_xlim(1) + backlash, ...
%     curr_ylim(1) + backlash, ...
%     curr_xlim(2) - curr_xlim(1) - 2 * backlash, ...
%     curr_ylim(2) - curr_ylim(1) - 2 * backlash];
% rect_handle = rectangle(...
%     'Position', rect_coordinates, 'EdgeColor', [0 0 0 ], 'LineWidth', 2);
for i = 1:highlighting_frames
    colorValue = 1 - i / highlighting_frames;
     set(rect_handle, 'EdgeColor', colorValue * rectangle_base_color);
     % debug
     writeVideo(m_night_shamalama, getframe(gcf));
end

%% Pause
pause_frames = 25;
for i = 1:pause_frames
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Scale 3 plotting
% Initialize
curr_xlim = xlim3;
curr_ylim = ylim3;
dt = 0.03;
for i = freeze_frame_2_3:1:length(Z3)
    time = dt*(i-1);
    contourf(x_vector3,y_vector3,Z3(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on
%     % Plot all points
%     plot(SOLN3(:,2), SOLN3(:,3), '.', 'MarkerSize', ...
%         curr_markerSize, 'Color', 0.8*[1 0 0]);
    % Plot ignited and unignited particles
    plot(SOLN3(SOLN3(:,4) <= time, 2), SOLN3(SOLN3(:,4) <= time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 0 0]);
    plot(SOLN3(SOLN3(:,4) > time, 2), SOLN3(SOLN3(:,4) > time, 3), ...
        '.', 'MarkerSize', ...
        curr_markerSize, 'Color', 0.8*[1 1 1]);
    hold off;
    % Scale
    xlim(curr_xlim);
    ylim(curr_ylim);
    daspect([1 1 1]); % pbaspect([1 1 1]);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Strip axes
    axis off;
%     set(gca, 'YTick', [], 'YTickLabel', {})
%     set(gca, 'XTick', [], 'XTickLabel', {})
    
    drawnow;
    % Debug
    writeVideo(m_night_shamalama, getframe(gcf));
end

%% Cleanup
close(m_night_shamalama);