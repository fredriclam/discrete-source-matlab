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
file_name_approx = 'TFLD1_*';
D = dir(file_name_approx);
file_name_tfld = D(1).name;
file_name_soln = ['SOLN' file_name_tfld(5:end)];

% Input data format parameters
x_res = 200+1; %800+1; % Make sure to plus one!
y_res = 100;
% t_res = 3;%+1; % Or use auto t_res below
% Input problem parameters
width_x = 100;
width_y = 50;
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

% Generate figure handle
% fig_h = figure(101);
% clf;

% Generate right-propagating contour plots out of each captured frame
for i = 11%1:t_res
    % OVERRIDE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     if i ~= 8
%         continue
%     end
    % Assign to separate figure window
%     figure(100+i);
    % Clear figure
%     clf;
    % Generate contour
    contourf(x_vector,y_vector,Z(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    % Generate contour, but shift out
%     shift_x = 4.5;
%     contourf([x_vector-shift_x x_vector+width_x-shift_x],...
%         y_vector,...
%         [Z(:,:,i)',zeros(size(Z,2),size(Z,1))],...
%         'LineStyle', 'none', 'LevelStep', contour_res);
%     axis([0,width_x,0,width_y-0.25]);
    
    % Generate contour and don't ask questions
    contourf(x_vector,...
        y_vector,...
        Z(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    set(gca, 'YTick', [0, 49.5], 'YTickLabel', {'0', '50'})
    
    % Generate contour and duplicate along y-direction
%     contourf(x_vector,...
%         [y_vector, y_vector + width_y,  y_vector + 2*width_y],...
%         [Z(:,:,i) Z(:,:,i) Z(:,:,i)]',...
%         'LineStyle', 'none', 'LevelStep', contour_res);
    
    
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    hold on;
    
    % Format and fix aspect ratio
    adjplot;
    set (gca, 'DataAspectRatio', [1 1 1]);
end