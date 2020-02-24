% Generate <CTM Fig 3>; also see figure3.m
% Traces the 1-D temperature profile of a flame in a given TFLD* file.
% Specify the approximate file name, physical problem parameters and the
% numerical parameters of the grid used to find the front.
% 
% Plots the 1-D temperature profile along the centre of the domain, plots
% the average theta profile (averaged across the domain width) for each
% grid line--all at one instant in time--and plots the continuum solution
% for the given physical parameters.

% Note: best 124, 134, 1500
% Control parameters
file_name_approx = 'TFLD1_*';
% Which instant in time to use (integer: numbered snapshot)
t_focus = 4;
% Problem physical parameters
theta_ign = 0.05;
tau_c = 0.1;
width_x = 800;
width_y = 50;

% Import file
D = dir(file_name_approx);
file_name_tfld = D(1).name;
data = importdata(file_name_tfld);

% Input numerical parameters
% Sampling grid resolution
x_res = 1600+1; % Make sure to plus one!
y_res = 100;
% Automatically adjust number of "snapshots" (time page resolution)
t_res = length(data)/x_res/y_res;
% disp(t_res);
% If chosen t_focus was higher, choose max t_focus instead
if t_focus > t_res
    t_focus = t_res;
end

% Reshape the vector into paged matrix; access by Z(m,n,T)
Z = reshape(data, [x_res,y_res,t_res]);

% Get centre-line value at specified instant in time
vector_theta_1 = Z(:,floor(y_res/4),t_focus);
vector_theta_2 = Z(:,floor(2*y_res/4),t_focus);
vector_theta_3 = Z(:,floor(3*y_res/4),t_focus);

% Calculate average theta profile across the domain width, for each grid
% line
vector_average_theta = mean(Z(:,:,t_focus),2);

% Calculate theta profile averaged across domain width and across each
% snapshot time (experimental)
% vector_super_average_theta = mean(mean(Z(:,:,:),3),2);

% Generate the x-coordinate vector
vector_x = linspace(0,width_x,x_res);

% Shift all curves to line up at the ignition temperature by
% shifting the coordinate system so that x = 0 is when
% theta = 0 for the real averaged profile.

% Find x such that average_theta(x) = theta_ign, and then
% shift the vector of x-values used to plot and calculate the
% continuum theta-profile by such x
for i = length(vector_x):-1:1
    if vector_average_theta(i) > theta_ign
        % Use this x for 0-th order approximation of front position
        x = vector_x(i);
        % Interpolate for better positioning
        t = (theta_ign - vector_average_theta(i)) / ...
            (vector_average_theta(i+1) - vector_average_theta(i));
        x = (1-t) * vector_x(i) + t * vector_x(i+1);
        % Shift vector x (for plotting and calculating continuum solution)
        vector_x = vector_x - x;
        break
    end
end

% Calculate continuum profile for given parameters
continuum_profile = zeros(length(vector_x),1);
for i = 1:length(vector_x)
    continuum_profile(i) = exact_flame_solution(...
        vector_x(i), theta_ign, tau_c);
end

% Extend plot lines with zero
vector_x_padded = [vector_x vector_x+width_x];
continuum_profile_padded = ...
    [continuum_profile; zeros(length(vector_x),1)];
vector_average_theta_padded = ...
    [vector_average_theta; zeros(length(vector_x),1)];
vector_theta_1_padded = ...
    [vector_theta_1; zeros(length(vector_x),1)];
vector_theta_2_padded = ...
    [vector_theta_2; zeros(length(vector_x),1)];
vector_theta_3_padded = ...
    [vector_theta_3; zeros(length(vector_x),1)];

% Plot
plot(vector_x_padded, continuum_profile_padded, 'k');
hold on
plot(vector_x_padded, vector_average_theta_padded,'r');
% Plot all
% plot(vector_x_padded, vector_theta_1_padded,':',...
%     'Color', [191 0 191]/255);
% plot(vector_x_padded, vector_theta_2_padded,':',...
%     'Color', [0 114 189]/255);
% plot(vector_x_padded, vector_theta_3_padded,':',...
%     'Color', [0 127 0]/255);

% plot(vector_x, vector_super_average_theta, 'g');


% Axis things
set(gca, 'YLim', [0, 1.5]);
xlabel '\itx'
ylabel '{\it\theta}'

% Legend
legend_labels = {'Continuum','Averaged',};
legend(legend_labels, 'Location', 'Best')


% % Old code------------------
% % Shifting the x vector based on middle line
% plotting_x_vector = linspace(0,width_x,x_res);
% for i = length(values_matrix(:,2)):-1:1 % backwards down middle line (col vec)
%     if values_matrix(i,2) < theta_ign
%         % Blank
%     else % Grab x of front in non-shifted frame
%         x = plotting_x_vector(i);
%         % Shift plot vector
%         plotting_x_vector = plotting_x_vector - x;
%         break
%     end
% end
% 
% % Plot selections
% figure(101);
% clf;
% plot(plotting_x_vector, values_matrix);
% % Labels
% xlabel 'x'
% ylabel '\theta'
% legend({'y @ 25%','y @ 50%','y @ 75%'});
% title (['Case \tau_c = ' num2str(tau_c)]);
% % Ref lines
% hold on;
% % ref_plotting_x_vector = [plotting_x_vector(1),...
% %     plotting_x_vector(length(plotting_x_vector))];
% % plot(ref_plotting_x_vector, [theta_ign, theta_ign], 'k');
% % plot(ref_plotting_x_vector, [1, 1], 'k');
% 
% % Copy size
% exact_y_vector = plotting_x_vector;
% for i = 1:length(plotting_x_vector)
%     exact_y_vector(i) = exact_flame_solution(plotting_x_vector(i), theta_ign, tau_c);
% end
% plot(plotting_x_vector, exact_y_vector, 'k');