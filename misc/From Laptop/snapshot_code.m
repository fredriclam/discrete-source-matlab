processed_data = result;

% t_final = 28;
% dt = 0.05;
% gif_filename = 'test_flame_gif.gif';
% frame_delay = 1/30;

x_min = 0; x_max = 200;
y_min = 0; y_max = 200;
figure(17);

t = 50;

% t_range = 0:dt:t_final;
% on_off_matrix = zeros(size(processed_data,1), 3, numel(t_range));

clf;
hold on;
for k = 1:size(processed_data,1)
    if t >= processed_data(k,4)
        plot(processed_data(k,2),processed_data(k,3),'r.');
    else
        plot(processed_data(k,2),processed_data(k,3),'g.');
    end
end
axis([x_min, x_max, y_min, y_max]);
xlabel 'x'
ylabel 'y'
% time_string = ['t = ' num2str(t, '%.3d')];
% annotation('textbox', [0.2 0.5 0.3 0.3], 'String', time_string, 'FitBoxToText', 'on')
% Snapshot

% close(17);
% 
% figure(18);
% t = 10;
% 
% % t_range = 0:dt:t_final;
% % on_off_matrix = zeros(size(processed_data,1), 3, numel(t_range));
% 
% clf;
% hold on;
% for k = 1:size(processed_data,1)
%     if t >= processed_data(k,4)
%         plot(processed_data(k,2),processed_data(k,3),'r.');
%     else
%         plot(processed_data(k,2),processed_data(k,3),'g.');
%     end
% end
% axis([x_min, x_max, y_min, y_max]);
% xlabel 'x'
% ylabel 'y'