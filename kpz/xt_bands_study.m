clear all; clc; clf;

% Load data
target_data_file = 'SOLN1_52511955-TIGN060.dat';
K = importdata(target_data_file);
Q = K.data;
x = Q(:,2);
y = Q(:,3);
t = Q(:,4);

% Remove artificial singularities (nonignitions)
for i = 1:length(x)
    if t(i) > 1e8
        t(i) = [];
        x(i) = [];
        y(i) = [];
    end
end

% Get residuals
ft = fittype( 'poly1' );
opts  = fitoptions( 'Method', 'LinearLeastSquares');
fitresult = fit(x, t, ft, opts );
slope = fitresult.p1;
yint = fitresult.p2;
linear = slope * x + yint;
residual = t - linear;

% x-window indices
LX = 100*ceil(max(x)/100);
i_min = floor(0.1*length(x));
i_max = floor(0.5*length(x));

% Get subset of vectors
xq = x(i_min:i_max);
yq = y(i_min:i_max);
rq = residual(i_min:i_max);
tq = t(i_min:i_max);

% Generate interpolated mesh plot. This looks like it smooths out what we
% want to see
% figure(17);
% RES = 250;
% x_range = linspace(min(xq), max(xq), RES);
% y_range = linspace(min(yq), max(yq), RES);
% [x_grid, y_grid] = meshgrid(x_range, y_range);
% Z = griddata(xq,yq,rq,x_grid,y_grid,'linear');
% mesh(x_grid,y_grid,Z);
% xlabel ('x','FontName','Times New Roman', 'FontSize', 24);
% ylabel ('y','FontName','Times New Roman', 'FontSize', 24);
% zlabel (['time delay with respect to ignition time expected from mean' ...
%     ' front speed'],...
%     'FontName','Times New Roman', 'FontSize', 24)
% adjplot
% title (target_data_file,'FontName','Times New Roman', 'FontSize', 24);

try
    close(1);
catch
end

% Residual plot, x-R collapse
figure(18);
plot(xq, rq,'.','MarkerSize',2);

% Space-time diagram
figure(19);
plot(xq, tq,'.','MarkerSize',2);

% With depth
figure(20);
scatter3(xq, yq, rq,6,yq,'filled');
xlabel ('\itx','FontName','Times New Roman', 'FontSize', 24);
ylabel ('\ity','FontName','Times New Roman', 'FontSize', 24);
zlabel ('{\itt}-E({\itt})','FontName','Times New Roman', 'FontSize', 24);

% xlabel ('x','FontName','Times New Roman', 'FontSize', 24);
% ylabel ('y','FontName','Times New Roman', 'FontSize', 24);
% zlabel (['time delay with respect to ignition time expected from mean' ...
%     ' front speed'],...
%     'FontName','Times New Roman', 'FontSize', 24)
adjplot
% title (target_data_file,'FontName','Times New Roman', 'FontSize', 24);
drawnow;
AXES = get(gca,'ZLim');
set(gca,'ZLim', AXES);
set(gca,'Xlim',[0.1*LX, 0.5*LX]);
colorbar;

L = 100;
num_slices = 4;
for i = 1:num_slices
    figure(20+2*i-1);
    y_min = (1/num_slices*(i-1))*L;
    y_max = (1/num_slices*i)*L;
    x_slice = [];
    y_slice = [];
    r_slice = [];
    for it = 1:length(xq)
        if yq(it) >= y_min && yq(it) <= y_max
            x_slice = [x_slice xq(it)];
            y_slice = [y_slice yq(it)];
            r_slice = [r_slice rq(it)];
        end
    end
    %     xq = x(i_min:i_max);
    %     yq = y(i_min:i_max);
    %     rq = residual(i_min:i_max);
    scatter3(x_slice, y_slice, r_slice,6,y_slice,'filled');
    %     caxis([0,200]);
    caxis([0,L]);
    set(gca,'Zlim',AXES);
    set(gca,'Xlim',[0.1*LX, 0.5*LX]);
    xlabel ('\itx','FontName','Times New Roman', 'FontSize', 24);
    ylabel ('\ity','FontName','Times New Roman', 'FontSize', 24);
    zlabel ('{\itt}-E({\itt})','FontName','Times New Roman', 'FontSize', 24);
    adjplot;
    colorbar;
    %     cloud2mesh(x_slice,y_slice, r_slice, 20+2*i, 1000);
end

% scatter3(xq,yq,rq,'k.');

% % 3D scatter plot
% % scatter3(xq,yq,rq,'Marker','.');
% scatter3(xq,yq,rq,6,rq,'filled');
% xlabel x
% ylabel y
% zlabel t

%
% figure(1);
% plot(x, t,'.','MarkerSize',2);
%
% ft = fittype( 'poly1' );
% opts  = fitoptions( 'Method', 'LinearLeastSquares');
% fitresult = fit(x, t, ft, opts );
%
% slope = fitresult.p1;
% yint = fitresult.p2;
%
% x_range = linspace(20,200);
% linear = slope * x + yint;
%
% residual = t - linear;
%
% figure(2);
% plot(x, residual,'.','MarkerSize',2);
% set(gca,'xlim',[20, 200]);

% contents = [x';residual'];
% theta = -45 * pi/180;
% R = @(theta) [cos(theta) sin(theta); -sin(theta) cos(theta)];
% i = 1;
% for v = contents
%     contents(:,i) = R(theta) * v;
%     i = i + 1;
% end
% rotated_x = contents(1,:);
% rotated_t_residual = contents(2,:);
% % rotated_t_residual(1) = rotated_t_residual(2);
%
% figure(3);
% plot(rotated_x, rotated_t_residual,'.','MarkerSize',2);
% set(gca,'xlim',[20, 200]);