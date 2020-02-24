x_res = 401;
y_res = 400;
contour_res = 0.005;
% Auto t_res
t_res = length(C{1})/x_res/y_res;
% Reshape the data into paged matrix; access by Z(m,n,T)
Z_new = reshape(C{1}, [x_res,y_res,t_res]);

% caxis_limits = [0,0.1];
caxis_limits = [0,1.5];

% Pre-allocate vectors
width_x = 100;
width_y = 100;
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

try
    close(hayao_miyazaki);
end
% Create video writer object
hayao_miyazaki = VideoWriter('ZMovieOutput2.avi','MPEG-4');
hayao_miyazaki.set('FrameRate', 30);
open(hayao_miyazaki);

for j = floor(0.15*t_res):t_res%1:t_res
    contourf(x_vector,y_vector,Z_new(:,:,j)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    xlim([25, 75]);
    ylim([25, 75]);

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
    drawnow;
    writeVideo(hayao_miyazaki, getframe(gcf));
end
close(hayao_miyazaki);