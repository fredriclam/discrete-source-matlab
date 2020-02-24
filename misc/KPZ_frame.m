processed_data = CLOUD;

% t = 2;
T_IGN = 0.4;
make_gif = 1;

t_final = 10; %8
dt = 0.5;
t_range = 2*dt:dt:t_final;
gif_filename = 'roughening_3.gif';
frame_delay = 1;

x_min = 0; x_max = 300;
y_min = 0; y_max = 100;
scan_res = 75; %100;%25/5; %100

figure;
axis ([0, 100, 25, 250]);
axis manual;
set(gca,'DataAspectRatio',[1 1 1])
%  set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
% set(gcf, 'Units', 'pixels', 'Position', [10, -100, 1000, 4000]);
% set(gca,'Position',[.1 .1 1 1]);

% Override
% on_off_matrix = zeros(size(processed_data,1), 3, numel(t_range));

scan_range_y = linspace(y_min,y_max,scan_res);
scan_range_x = linspace(x_min,x_max,scan_res);
Z = zeros(scan_res, scan_res);
% scan_vector = zeros(2,scan_res);
% scan_vector(2,:) = scan_range_y;

i = 1;
for t = t_range
    %     t = 2;
    clf;
    hold on;
    
    % Plot contours
    n = 1;
    for y = scan_range_y
        m = 1;
        for x = scan_range_x
            % Compute theta
            theta = 0;
            for k = 1:size(processed_data,1)
                if t > processed_data(k,4)
                    theta = theta + images_green_2d_diag_correct(...
                        x-processed_data(k,2), ...
                        y-processed_data(k,3), ...
                        t-processed_data(k,4), ...
                        y_max-y_min, ...
                        1e-9);
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
    contour_handle = contourf(scan_range_y, scan_range_x, Z,...
        'LineStyle', 'none', 'LevelStep', 0.01);
    %     axis([y_min, y_max, x_min, x_max]);
    colormap hot;
    %     plot(scan_vector(1,:), scan_vector(2,:), '*');
    caxis([0, 2]);
%     colorbar;
    contour(scan_range_y, scan_range_x, Z, [T_IGN T_IGN] ,...
        'linecolor', 'green', 'LineWidth', 6);
    
    % Plot particles as points
    for k = 1:size(processed_data,1)
        if t >= processed_data(k,4) % on: black
            plot(processed_data(k,3),processed_data(k,2),'k.',...
                'MarkerSize', 2);
        else
            plot(processed_data(k,3),processed_data(k,2),'w.',...
                'MarkerSize', 2);
        end
    end
    
    % Fit and format
    %     axis([x_min, x_max, y_min, y_max]);
    % xlabel 'x'
    % ylabel 'y'
    % time_string = ['t = ' num2str(t, '%.3d')];
    %     annotation('textbox', [0.2 0.5 0.3 0.3], 'String', time_string, 'FitBoxToText', 'on')
    % Snapshot
    box on;
    set(gca, 'fontname', 'Times New Roman', 'fontsize', 16)
    %     set(gcf, 'units','normalized','Position',[.15 -.5 2*.8*10/16 2*.8])
    axis ([0, 100, 25, 250]);
    axis manual;
    set(gcf,'units','normalized','Position',[.1 -.5 3*1/12 3*1]);
    drawnow;
    
    
    % Capture image window figure as matrix
    if make_gif
        frame = getframe();
        im = frame2im(frame);
        [im_matrix, cmap] = rgb2ind(im, 256);
        drawnow;
        if i == 1
            if exist(gif_filename, 'file')
                delete(gif_filename);
                disp 'Overwriting file.';
            end
            imwrite(im_matrix, cmap,...
                gif_filename, 'gif',...
                'LoopCount', Inf,...
                'DelayTime', frame_delay);
        else
            imwrite(im_matrix, cmap,...
                gif_filename, 'gif',...
                'WriteMode', 'append',...
                'DelayTime', frame_delay);
        end
        
        % Save figure
        savefig(['frame' num2str(i) '.fig']);
    end
    i = i + 1;
end