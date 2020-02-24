% Import TFLD file into contour plot

% TFLD file name
file_name_tfld = 'TFLD662_63012926.dat';
file_name_soln = 'SOLN662_63012926.dat';

% Parameters needed to import vector of temperature points
x_res = 600+1; % Make sure to plus one!
y_res = 200;
t_res = 12;%+1;
% Problem parameters
width_x = 60;
width_y = 20;

% Reshape the data into paged matrix; access by Z(m,n,T)
data = importdata(file_name_tfld);
Z = reshape(data, [x_res,y_res,t_res]);

% Pre-allocate vectors
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

% Graft
k = 3;
Zg = [Z(:,:,k), Z(:,:,k), Z(:,:,k)];
yg = [y_vector-width_y, y_vector, y_vector+width_y];

% Index beginning
i_start = 2;

figure(1);
clf;

%     % Generate contour plot
%     contourf(y_vector,x_vector,Z(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.1);
% Rotated contour plot
contourf(x_vector,yg,Zg(:,:)',...
    'LineStyle', 'none', 'LevelStep', 0.05);

% Contour stuff
colormap hot;
caxis([0, 1.5]);
hold on;

% Decorate
adjplot;
set (gca, 'DataAspectRatio', [1 1 1]);

filename = 'SOLN662_63012926.dat';
data = importdata(filename);
data = data.data;
RES_T = 5000;

% Generate periodic data
dots_x = [data(:,2);data(:,2);data(:,2)];
dots_y = [data(:,3)-20;data(:,3);data(:,3)+20];
dots_t = [data(:,4);data(:,4);data(:,4)];

% Important!
L = 20;
sampling_dt = 1;

% Choose isotherm plot time
t_max = k*sampling_dt;

% Generate mask
mask = dots_t <= t_max;
% Hot particles
scatter(dots_x(mask), dots_y(mask),150,'w','.');
hold on;
% Cold particles
% scatter(dots_x(~mask), dots_y(~mask),150,'b','.');

% Choose particle to focus on by x
N = find(abs(dots_x-32.23)<1e-2);
N = 1643;
x_0 = data(N-1200,2);
y_0 = data(N-1200,3);

% Focus particle
scatter(dots_x(N), dots_y(N),500,'k','.');

figure(2);
% Get time history
t_range = linspace(0.1, t_max, RES_T);
theta_range = zeros(1,length(t_range));
for j = 1:length(t_range)
    t = t_range(j);
    theta = 0;
    % Sum for all source particles
    for i = 1:size(data,1)
        x = data(i,2);
        y = data(i,3);
        t_0 = data(i,4);
        
        time = t-t_0;
        if time < 0
            break
        elseif time ~= 0
            contribution = ...
                exp(-((x-x_0)^2 + (y-y_0)^2) / 4 / time) + ...
                exp(-((x-x_0)^2 + (y-y_0+L)^2) / 4 / time) + ...
                exp(-((x-x_0)^2 + (y-y_0-L)^2) / 4 / time);
            contribution = contribution/(4*pi*(time));
            theta = theta + contribution;
        end
    end
    theta_range(j) = theta;
end

i_split = find (t_range>dots_t(N),1)-1;
plot(t_range(1:i_split),theta_range(1:i_split));
axis ([5, 7, 0, 1.5]);
hold on;
plot(t_range(i_split:length(t_range)),...
    theta_range(i_split:length(t_range)),...
    'r')