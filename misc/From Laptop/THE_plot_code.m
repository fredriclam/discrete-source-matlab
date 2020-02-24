% Outputs gif, figures of intermediates.
% Single image. Nonzero burn time.%=
% Load solution matrix into "solution" as:
%       col2:x col3:y col4:t_ign
% Load "longtime.mat" for interpolation table

output_gif_filename = 'trymeout_q.gif';
output_fig_radical = 'trymeout_q';

% Appearance options
frame_delay = .5;
DOT_SIZE = 3;
FRONT_COLOUR = 'green';
FRONT_WEIGHT = 5;
FONT_SIZE = 16;
RES_FACTOR = 1;

% Problem parameters
T_ign = 0.5;
tr = 10;
width_x = 100;
width_y = 100;

% Plot's time-resolution
t_initial = 50;
t_final = 75;
dt = 5;
t_range = t_initial:dt:t_final;
% Plot's space-resolution
resolution_x = RES_FACTOR*width_x + 1;
resolution_y = RES_FACTOR*width_y + 1;

% Open figure #1
figure(1);
axis([0 width_x, 0 width_y]);
set (gca, 'DataAspectRatio', [1 1 1]);

% Initialize plotting matrices
x_vector = linspace(0, width_x, resolution_x);
y_vector = linspace(0, width_y, resolution_y);
Z = zeros(resolution_x, resolution_y);

i = 1;
for t = t_range
    % Compute field
    n = 1;
    for y = y_vector
        m = 1;
        for x = x_vector
            % Compute theta
            theta = 0;
            for k = 1:size(solution,1)
                if t > solution(k,4)
                    theta = theta + ...
                    T_i_tr_boss(t-solution(k,4), ...
                        (solution(k,2)-x_vector(m))^2 + (solution(k,3)-y_vector(n))^2, ...
                        tr, lookup, dq, q_max) + ...
                    T_i_tr_boss(t-solution(k,4), ...
                        (solution(k,2)-x_vector(m))^2 + (solution(k,3)+Y_length-y_vector(n))^2, ...
                        tr, lookup, dq, q_max) + ...
                    T_i_tr_boss(t-solution(k,4), ...
                        (solution(k,2)-x_vector(m))^2 + (solution(k,3)-Y_length-y_vector(n))^2, ...
                        tr, lookup, dq, q_max);
                else
                    break
                end
            end
            % Assign theta to height map
            Z(m,n) = theta;
            m = m + 1;
        end
        n = n + 1;
    end
    
    % Refresh figure
    clf;
    % Generate contour plot
    contour_handle = contourf(x_vector, y_vector, Z,...
        'LineStyle', 'none', 'LevelStep', 0.01);
    % Squish window and repaint
    axis([0 width_x, 0 width_y]);
    set (gca, 'DataAspectRatio', [1 1 1]);
    hold on;
    colormap hot;
    caxis([0, 1]);
    %     colorbar;
    % Superimpose highlighted contour of front
    contour(x_vector, y_vector, Z, [T_ign T_ign] ,...
        'linecolor', FRONT_COLOUR, 'LineWidth', FRONT_WEIGHT);
    
    % Plot particles as points
    for k = 1:size(solution,1)
        if t >= solution(k,4) % on: black
            plot(solution(k,3),solution(k,2),'k.',...
                'MarkerSize', DOT_SIZE);
        else
            plot(solution(k,3),solution(k,2),'w.',...
                'MarkerSize', DOT_SIZE);
        end
    end
    
    % More decorating
    box on;
    set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)
    drawnow;
    %     set(gcf, 'units','normalized','Position',[.15 -.5 2*.8*10/16 2*.8])
%     axis ([0, 100, 25, 250]);
%     axis manual;
%     set(gcf,'units','normalized','Position',[.1 -.5 3*1/12 3*1]);
    
    
    % xlabel 'x'
    % ylabel 'y'
    % time_string = ['t = ' num2str(t, '%.3d')];
    %     annotation('textbox', [0.2 0.5 0.3 0.3], 'String', time_string, 'FitBoxToText', 'on')
    % Snapshot
    
    % Save figure to specified path
    savefig([output_fig_radical num2str(i) '.fig']);
    % Run-of-the-mill gif code
    frame = getframe();
    im = frame2im(frame);
    [im_matrix, cmap] = rgb2ind(im, 256);
    drawnow;
    if i == 1
        if exist(output_gif_filename, 'file')
            delete(output_gif_filename);
            disp 'Overwriting file.';
        end
        imwrite(im_matrix, cmap,...
            output_gif_filename, 'gif',...
            'LoopCount', Inf,...
            'DelayTime', frame_delay);
    else
        imwrite(im_matrix, cmap,...
            output_gif_filename, 'gif',...
            'WriteMode', 'append',...
            'DelayTime', frame_delay);
    end
    i = i + 1;
end