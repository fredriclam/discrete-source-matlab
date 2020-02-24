filename = 'SOLN240_831115459.dat';
data = importdata(filename);
data = data.data;
RES_T = 500;

% Generate periodic data
dots_x = [data(:,2);data(:,2);data(:,2)];
dots_y = [data(:,3)-20;data(:,3);data(:,3)+20];
dots_t = [data(:,4);data(:,4);data(:,4)];

% Important!
L = 20;

% Choose isotherm plot time
t_max = 8;

% Generate mask
mask = dots_t <= t_max;
% Hot particles
scatter(dots_x(mask), dots_y(mask),150,'w','.');
hold on;
% Cold particles
% scatter(dots_x(~mask), dots_y(~mask),150,'b','.');

% Choose particle to focus on by number
N = 777;
x_0 = data(N,2);
y_0 = data(N,3);

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

plot(t_range,theta_range);