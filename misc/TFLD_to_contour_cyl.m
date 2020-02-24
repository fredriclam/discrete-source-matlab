% TFLD_to_contour_cyl
%   Uses MATLAB graphics to read TFLD file and render 3-d contour plot.
%   Too slow to be useful.

% cd 'c:\users\fredric\desktop\Testing\Cylinder Graphical'
% 
% Search for TFLD file specified name
file_name_approx = 'TFLDn1s0*';
D = dir(file_name_approx);
file_name_tfld = D(1).name;
file_name_soln = ['SOLN' file_name_tfld(5:end)];

% Input data format parameters
x_res = 100+1; % Make sure to plus one! % 100+1
y_res = 100+1; % 30+1
z_res = 100+1; % 30+1
% t_res = 3;%+1; % Or use auto t_res below
% Input problem parameters
width_x = 50;
width_y = 20;
width_z = 20;
% Config
caxis_limits = [0, 1]; % [0, 1.5]

% Import data
data = importdata(file_name_tfld);

% Auto t_res
t_res = length(data)/x_res/y_res/z_res;

% Reshape the data into paged matrix
% Z = reshape(data, [x_res,y_res,z_res,t_res]);
Z = row_major_parse(data, x_res, y_res, z_res, t_res);

% Pre-allocate vectors
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(-0.5*width_y, 0.5*width_y, y_res);
z_vector = linspace(-0.5*width_z, 0.5*width_z, z_res);

% Generate figure handle
fig_h = figure(101);
clf;

for i = 1:1
    % Garbage
    % Z1 = double(squeeze(Z));
    % Time slice
    Z1 = Z(:,:,:,i);
    % Pretreat: -1 -> NaN
    Z1(Z1 == -1) = NaN;
    % Pretreat: amplify
    Z1 = 1*Z1;
    % Pretreat: smooth
    Z1 = smooth3(Z1, 'gaussian');
    % Generate meshgrid
    [p, q, r] = meshgrid(x_vector, y_vector, z_vector);
    
%     % (Trash) Patch plot
%     patch(isocaps(Z1,.4), 'FaceColor', 'Interp', 'EdgeColor', 'None');
%     p1 = patch(isosurface(Z1,.4), ...
%         'FaceColor', 'blue', 'EdgeColor', 'none');
%     isonormals(Z1, p1);
%     % Cslice
%     h = contourslice(p, q, r, ...
%         Z1, 1:x_res, 1:y_res, 1:z_res);
%     set(h, 'EdgeColor', 'none', 'FaceColor', 'interp');
%     alpha(.1);
    
    % !! Slice plot
    h = slice(p, q, r, ...
        Z1, 1:x_res, [], [],...
        'cubic');
    set(h, 'EdgeColor', 'none', 'FaceColor', 'interp');
    alpha(.1);
    
%     % Iso-surface plot
%     % Generate patch
% %     patch1 = patch(isosurface(p, q, r, Z1, 0.1));
% %     isonormals(p,q,r,Z1,patch1);
% %     patch
%     
% %     isosurface(p, q, r, Z1, 0.1);
% %     isosurface(p, q, r, Z1, 0.2);
% %     isosurface(p, q, r, Z1, 0.3);
%     isosurface(p, q, r, Z1, 0.4);
%     isosurface(p, q, r, Z1, 0.5);
%     isosurface(p, q, r, Z1, 0.6);
%     isosurface(p, q, r, Z1, 0.7);
% %     isosurface(p, q, r, Z1, 0.8);
% %     isosurface(p, q, r, Z1, 0.9);
% %     isosurface(p, q, r, Z1, 1);
%     


    % Colormap colour
    colormap hot;
    % Set caxis
    caxis(caxis_limits);
    % Set axis
    axis([0, width_x,...
        -0.5*width_y, 0.5*width_y,...
        -0.5*width_z, 0.5*width_z]);
    % Lighting
    view([1,0,0]);
    drawnow;
    camlight;
    drawnow;
end