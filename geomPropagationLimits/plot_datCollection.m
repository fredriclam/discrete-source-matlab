% Plot large data collection (e.g. datCyl, datSlab) that are arrays of
% structs with data from .PROP files

% Define active collection
active = datCyl;

tau_c_vector = unique([active.tau_c]);
theta_ign_vector = unique([active.theta_ign]);

% Data grid
crit_length_matrix = nan(length(tau_c_vector), length(theta_ign_vector));
upper_error_matrix = nan(size(crit_length_matrix));
lower_error_matrix = nan(size(crit_length_matrix));
ch_width_matrix = nan(size(crit_length_matrix));

for k = 1:length(active)
    % Read entry
    entry = active(k);
    % Check location
    i = find(tau_c_vector == entry.tau_c);
    j = find(theta_ign_vector == entry.theta_ign);
    % Replace entry at (i,j)
    crit_length_matrix(i,j) = entry.critical_dimension;
    ch_width_matrix(i,j) = 1 ./ entry.characteristic_scale;
    lower_error_matrix(i,j) = entry.critical_dimension - entry.ci_lower;
    upper_error_matrix(i,j) = entry.ci_upper - entry.critical_dimension;
end

% Make plot
figure(2346); clf;
INIT_INDEX = 4;
for i = INIT_INDEX:size(crit_length_matrix,2)
    crit_lengths = crit_length_matrix(:,i);
    plot(tau_c_vector(~isnan(crit_lengths)), ...
        crit_lengths(~isnan(crit_lengths)));
    if i == INIT_INDEX
        hold on
    end
end
set(gca, 'XScale', 'log');

figure(2347); clf;
for i = INIT_INDEX:size(ch_width_matrix,2)
    crit_lengths = ch_width_matrix(:,i);
    plot(tau_c_vector(~isnan(crit_lengths)), ...
        crit_lengths(~isnan(crit_lengths)));
    if i == INIT_INDEX
        hold on
    end
end
set(gca, 'XScale', 'log');


% Sample error bar plot
% errorbar(tau_c_vector', crit_length_matrix(:,1), ...
%     lower_error_matrix, upper_error_matrix);

%% Other plot
% Plot crit_length / sqrt(tau_c) vs. tau_c
figure(777);

x_plot = tau_c_vector';
y_plot_matrix = crit_length_matrix ./ ...
    sqrt(meshgrid(tau_c_vector, zeros(size(crit_length_matrix,2),1)))';

for i = INIT_INDEX:size(y_plot_matrix,2)
    y_plot = y_plot_matrix(:,i);
    plot(x_plot(~isnan(y_plot)), ...
        y_plot(~isnan(y_plot)));
    if i == INIT_INDEX
        hold on
    end
end

% Quick plot (ends at NaNs)
% plot(tau_c_vector', crit_length_matrix ./ ...
%     sqrt(meshgrid(tau_c_vector, zeros(size(crit_length_matrix,2),1)))');

set(gca, 'yscale', 'log', 'xscale' , 'log')

%% Legend (abridged)

% legend({'\theta_{ign} = 0.05', ...
% '\theta_{ign} = 0.1', '\theta_{ign} = 0.2', '\theta_{ign} = 0.3'});

legend({...
...'$\theta_\mathrm{ign} = 0.05$', ...
'$\theta_\mathrm{ign} = 0.1$', ...
'$\theta_\mathrm{ign} = 0.2$', ...
'$\theta_\mathrm{ign} = 0.3$'} ...
,'interpreter', 'latex' ...
);

%% Scaling

% crit_length_matrix_slab = crit_length_matrix;
% OR
% crit_length_matrix_cyl = crit_length_matrix;
% and then
% scaling_matrix = crit_length_matrix_cyl ./ crit_length_matrix_slab;

figure(3346); clf;
INIT_INDEX = 4;
for i = INIT_INDEX:size(crit_length_matrix,2)
    x = scaling_matrix(:,i);
    plot(tau_c_vector(~isnan(x)), ...
        x(~isnan(x)));
    if i == INIT_INDEX
        hold on
    end
end
set(gca, 'XScale', 'log');