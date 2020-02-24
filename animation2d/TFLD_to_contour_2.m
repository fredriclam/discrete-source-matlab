% Not actually useful!!!!!!!!!!!!!!! Use version 1 instead
% Import TFLD file into contour plot
% Input required:
%     x_res: number of grid points in propagation direction
%     y_res: number of grid points in y-direction
%     t_res: (can use automatic version) number of frames captured
%     width_x: physical length in propagation direction
%     width_y: physical width in y
%     file_name_approx: approximate name of the TFLD file
%     caxis_limits: limits of the contour value axis
%     contour_res: step resolution of isocontours for the contourf function

% Search for TFLD file specified name
file_name_approx = 'TFLD23_*';
D = dir(file_name_approx);
file_name_tfld = D(1).name;
file_name_soln = ['SOLN' file_name_tfld(5:end)];
file_name_soln = ['SOLN' file_name_tfld(5:end)];
% Override to select specific frame (can leave empty or delete)
override = 3;

% Input data format parameters
x_res = 200+1; % Make sure to plus one!
y_res = 200;
% t_res = 3;%+1; % Or use auto t_res below
% Input problem parameters
width_x = 50;
width_y = 50;
theta_ign = 0.5; % Only needed to highlight the ignition isotherm
% Config
caxis_limits = [0, 1.5];
contour_res = 0.05; % Step resolution of contour map

% Import data
data = importdata(file_name_tfld);

% Auto t_res
t_res = length(data)/x_res/y_res;

% Reshape the data into paged matrix; access by Z(m,n,T)
Z = reshape(data, [x_res,y_res,t_res]);

% Pre-allocate vectors
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

% Range of i
if ~exist('override','var') || isempty('override')
    range_i = 1:t_res;
else
    range_i = override;
end

% Generate right-propagating contour plots out of each captured frame
for i = range_i
    % Assign to separate figure window
    figure(100+i);
    % Clear figure
    clf;
    % Generate contour
    contourf(x_vector,y_vector,Z(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    hold on;
    % Decorate and fix aspect ratio
    adjplot;
    set (gca, 'DataAspectRatio', [1 1 1]);
    
%     % Also highlight the front
%     hold on
%     % Generate front contour only for arbitrary middle portion of the
%     % domain
%     contour(...
%         x_vector(40:160),...
%         y_vector,...
%         Z(40:160,:,i)',...
%         [theta_ign theta_ign] ,... % Range of contour plotting
%         'linecolor', 'magenta',...
%         'LineWidth', 5);
end