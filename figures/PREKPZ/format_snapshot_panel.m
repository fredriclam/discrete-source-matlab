% Portion of <CTM fig 1/fig 3>
% Formats contour figures (snapshots) into panels to fit together into
% mosaic figure.

% Used for multiple figures, so watch out!

% Specify figure_name below and range of test case numbers to process

% Check manual override below

% Specify range of figures to take
range = [1];
% Resolution of contour level step
level_step_resolution = .001; % Quality
% level_step_resolution = .1; % Speedy

% Loop over each figure
for i = range
    % Open figure
    figure_name = ['YYY.fig']; % % % Manual Override
    %figure_name = ['#' num2str(i) '.fig'];
    h = openfig(figure_name, 'visible');
    drawnow;
    
    % Get axes
    ax = get(h, 'CurrentAxes');
    % Prescribed format
    axis([70 120 0 50])
    set(ax, ...
        ...'YTickLabel',{'0', '10', '20', '30', '40', '50'},...
        'YTickLabel',{'', '', '', '', '', ''},...
        ...{'0','10','20','30','40','50'}
        'YTick',[0, 10, 20, 30, 40, 50],...
        ...'YTick',[0 10 20 30 40 49.75],...
        ...'YTick',[60 70 80 90 100 110],...
        'XTickLabel',{'', '', '', '', '', ''},...
        'XTick',[70, 80, 90, 100, 110, 120],...
        ...'XTick',[0 10 20 30 40 50],...
        'YMinorTick','on',...
        'XMinorTick','on',...
        'TickDir','out',...
        'TickLength',[0.04;0.1],...
        'Layer','top',...
        'FontSize',24,...
        'LineWidth',3,...
        'FontName','Times New Roman',...
        'DataAspectRatio',[1 1 1],...
        'CLim',[0 1.5]);
    
    % Axis labels
%     xlabel('\itx','FontSize', 36);
%     ylabel('\ity','FontSize', 36);

    % Get grandchild: contour object handle
    ch = get(h,'Children');
    if length(ch) > 1
        ch = ch(2);
    end
    ch = get(ch,'Children');
    if length(ch) > 1
        ch = ch(1);
    end
    
    % Set resolution of contour object
    set(ch, 'LevelStep', level_step_resolution)
    % Output size set (resizes whole window, works on my laptop)
    set(h,'Position',[160 -200 492 498])
    
    % Output eps
    drawnow;
%     % Export base image (with axes)
%     hgexport(h,['#' num2str(i) '_base.eps'])
    % Export pure contour
%     hgexport(h,['#' num2str(i) '_contour.eps'])

    % Adjoint functions for <Fig 3>
    % Plot lines
    hold on
    elevation = 1/4*49.75;
    line_width = 3;
    plot([0, 50], elevation*[1,1], ':',...
        'LineWidth', line_width,...
        'Color', [191 0 191]/255)
    plot([0, 50], elevation*[2,2], ':',...
        'LineWidth', line_width,...
        'Color', [0 114 189]/255)
    plot([0, 50], elevation*[3,3], ':',...
        'LineWidth', line_width,...
        'Color', [0 127 0]/255)

end

