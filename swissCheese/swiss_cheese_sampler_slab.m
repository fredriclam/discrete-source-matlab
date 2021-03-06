% Global parameters
% Soft-sphere diameter
D = 1;
% Aspect ratio: length to xi (key dimension)
LENGTH_AR = 10;
% Aspect ratio: width to xi (periodic dimension)
WIDTH_AR = LENGTH_AR;

% Density x xi
DENSITY_RES = 30;
XI_RES = 15;
N_TRIALS = 100;
% Examine density � xi range for cylinder
geom = 'slab';
density_range = linspace(1,2,DENSITY_RES);
xi_range = linspace(1,3.,XI_RES);
success_matrix = zeros(length(density_range), length(xi_range));
path_length_matrix = zeros(length(density_range), length(xi_range));
% SCIENCE
for trial_number = 1:N_TRIALS
    for i = 1:length(density_range)
        density = density_range(i);
        for j = 1:length(xi_range)
            xi = xi_range(j);
            % Domain width: 10 times the thickness, then periodic
            domain_width = WIDTH_AR*xi; 
            domain_length = LENGTH_AR*xi;
            [success, time, ~, ~] = swiss_cheese_run_super(geom, D, ...
                xi, domain_width, domain_length, density);
            success_matrix(i,j) = success_matrix(i,j) + success;
            if success
                path_length_matrix(i,j) = path_length_matrix(i,j) + time;
            end
        end
        disp(['Trial ' num2str(trial_number) ': nDensity = ' num2str(density)])
    end
end
% Save originals
original_path_length_matrix = path_length_matrix;
original_success_matrix = success_matrix;

% Compute average path length on success
path_length_matrix(success_matrix ~= 0) = path_length_matrix(success_matrix ~= 0) ...
    ./ success_matrix(success_matrix ~= 0);
% Compute success rate
success_matrix = success_matrix / N_TRIALS;

% Compute the speed matrix (slab length on shortest path length)
true_speed_matrix = zeros(length(density_range), length(xi_range));
% Divide by averaged length
for j = 1:length(xi_range);
    xi = xi_range(j);
    true_speed_matrix(:,j) = (LENGTH_AR*xi) ./ path_length_matrix(:,j);
end

% Save temporary file
save('temp_slab.mat');

% Plot
figure(31); clf;
subplot(1,2,1);
surf(xi_range, density_range, success_matrix);
title 'Slab propagation probability'
xlabel '\xi';
ylabel 'Number density';
zlabel 'P'
subplot(1,2,2);
surf(xi_range, density_range, true_speed_matrix);
title 'Slab propagation speed on success'
xlabel '\xi';
ylabel 'Number density';
zlabel '\its'

% 3D swiss cheese: eta_c = 0.341 889 (reduced number density)