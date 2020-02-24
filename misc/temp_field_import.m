% Deprecated

in_name = 'TFLD2_711111513.dat';
output_gif_name = 'test_1.gif';

% Input Parameters
x_res = 200+1; % Make sure to plus one!
y_res = 200;
t_res = 3;%+1;
width_x = 50;
width_y = 50;
starting_frame = 2;

% Output parameters
frame_delay = 0.15; % 0.15 for 40 frames; 0.25 for 20 frames

% % Import vector as in_vector
% x_res = 1000+1; % Make sure to plus one!
% y_res = 100; % +1 ?
% t_res = 20+1;
% width_x = 500;
% width_y = 50;

% Import
Z = importdata(

% Reshape the vector into paged matrix; access by Z(m,n,T)
Z = reshape(Z, [x_res,y_res,t_res]);
%
% Zn2 = reshape(data_1en2, [x_res,y_res,t_res]);
% Zn1 = reshape(data_1en1, [x_res,y_res,t_res]);
% Z0 = reshape(data_1e0, [x_res,y_res,t_res]);
% Z1 = reshape(data_1IMG, [x_res,y_res,t_res]);
% Z2 = reshape(data_lotsIMG, [x_res,y_res,t_res]);

x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

figure(1);
for i = starting_frame:t_res %%%%
    clf;
%     subplot(2,3,1);
    contourf(y_vector,x_vector,Z(:,:,i),...
        'LineStyle', 'none', 'LevelStep', 0.01);
%     contourf(y_vector,x_vector,Zn2(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
   
    colormap hot;
    caxis([0, 1]);
    
    make_this_plot_look_nice;
    %
    generate_gif_frame(output_gif_name,i-starting_frame+1,frame_delay);
    
    
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)

    
    
    %
    
%     subplot(2,3,2);
%     contourf(x_vector,y_vector,Zn1(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)
%     
%     subplot(2,3,3);
%     contourf(x_vector,y_vector,Z0(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)
% 
%     subplot(2,3,4);
%     contourf(x_vector,y_vector,Z1(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)
%     
%     subplot(2,3,5);
%     contourf(x_vector,y_vector,Z2(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     set (gca, 'DataAspectRatio', [1 1 1]);
%     set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)

    %
    
%     pause;

    %
    
%     subplot(1,2,1);
%     contourf(y_vector,x_vector,Z1(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     make_this_plot_look_nice;
%     title '1 Image, \tau_c = 1000'
%     
%     subplot(1,2,2);
%     contourf(y_vector,x_vector,Z2(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.01);
%     colormap hot;
%     caxis([0, 1]);
%     make_this_plot_look_nice;
%         title '5 Image, \tau_c = 1000'
% 
%     if i == 1 % Inspection
%         pause;
%     end
    savefig([output_gif_name(1:length(output_gif_name)-4) '_frame' num2str(i-starting_frame+1) '.fig']);
end

