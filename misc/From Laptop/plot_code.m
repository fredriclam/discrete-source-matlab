processed_data = result;

t_final = 28;
dt = 0.05;
gif_filename = 'test_flame_gif.gif';
frame_delay = 1/30;

x_min = 0; x_max = 30;
y_min = 0; y_max = 30;
figure(17);

t_range = 0:dt:t_final;
% on_off_matrix = zeros(size(processed_data,1), 3, numel(t_range));

i = 1;
for t = t_range
    clf;
    hold on;
    for k = 1:size(processed_data,1)
        if t >= processed_data(k,5)
            plot(processed_data(k,2),processed_data(k,3),'r.');
        else
            plot(processed_data(k,2),processed_data(k,3),'g.');
        end
    end
    axis([x_min, x_max, y_min, y_max]);
    xlabel 'x'
    ylabel 'y'
    time_string = ['t = ' num2str(t, '%.3d')];
    annotation('textbox', [0.2 0.5 0.3 0.3], 'String', time_string, 'FitBoxToText', 'on')
    % Snapshot
    
    % Capture image window figure as matrix
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
    i = i + 1;
end

close(17);