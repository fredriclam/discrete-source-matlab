% Experimental
% Generate interpolated mesh plot. This looks like it smooths out what we
% want to see. Written for the "speed bands" in 2D discrete combustion
% system in the x-t plots.

function cloud2mesh(xq, yq, rq, figure_num, RES)
figure(figure_num);

x_range = linspace(min(xq), max(xq), RES);
y_range = linspace(min(yq), max(yq), RES);
[x_grid, y_grid] = meshgrid(x_range, y_range);
Z = griddata(xq,yq,rq,x_grid,y_grid,'linear');
mesh(x_grid,y_grid,Z);
xlabel ('x','FontName','Times New Roman', 'FontSize', 24);
ylabel ('y','FontName','Times New Roman', 'FontSize', 24);
zlabel (['time delay with respect to ignition time expected from mean' ...
    ' front speed'],...
    'FontName','Times New Roman', 'FontSize', 24)
adjplot
% title (target_data_file,'FontName','Times New Roman', 'FontSize', 24);