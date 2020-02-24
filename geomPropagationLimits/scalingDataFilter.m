%% Load in the data
% See critDimDataExtract

%% Add ci_lower and ci_upper parameters to data
% for i = 1:length(data_cleaned)
%     data_cleaned(i).ci_lower = data_cleaned(i).ci(1);
%     data_cleaned(i).ci_upper = data_cleaned(i).ci(2);
% end

%% Plot (cyl)
figure(36); clf;
theta_ign_list = ...
    [datCyl(1).theta_ign; ...
    datCyl(13).theta_ign; ...
    datCyl(25).theta_ign; ...
    datCyl(37).theta_ign; ...
    datCyl(48).theta_ign; ...
    datCyl(57).theta_ign];

range = 1:12;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]); hold on;
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]); hold on;

range = 13:24;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]);
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]);

range = 25:36;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]);
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]);

range = 37:47;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]);
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]);

range = 48:56;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]);
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]);

range = 57:64;
% errorbar([datCyl(range).tau_c], [datCyl(range).critical_dimension], ...
%     [datCyl(range).critical_dimension]-[datCyl(range).ci_lower], ...
%     [datCyl(range).ci_upper]-[datCyl(range).critical_dimension]);
plot([datCyl(range).tau_c], [datCyl(range).critical_dimension]);

legend(num2str(theta_ign_list));
set(gca,'XScale','log')

%% Plot (slab)
figure(37); clf;

range = 1:12;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]); hold on;
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]); hold on;

range = 13:24;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]);
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]);

range = 25:37;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]);
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]);

range = 38:49;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]);
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]);

range = 50:59;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]);
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]);

range = 60:65;
% errorbar([datSlab(range).tau_c], [datSlab(range).critical_dimension], ...
%     [datSlab(range).critical_dimension]-[datSlab(range).ci_lower], ...
%     [datSlab(range).ci_upper]-[datSlab(range).critical_dimension]);
plot([datSlab(range).tau_c], [datSlab(range).critical_dimension]);

legend(num2str(theta_ign_list));
set(gca,'XScale','log')

%% Look at scaling ratio
% Build data matrix
theta_ign_vector = ...
    union(unique([datCyl.theta_ign]), unique([datSlab.theta_ign]));
tau_c_vector = ...
    union(unique([datCyl.tau_c]), unique([datSlab.tau_c]));
dimension_cyl = nan(length(theta_ign_vector), length(tau_c_vector));
dimension_slab = nan(length(theta_ign_vector), length(tau_c_vector));

% Reshape data in datCyl to matrix of critical dimension
for i = 1:length(datCyl)
    index_theta_ign = find(theta_ign_vector==datCyl(i).theta_ign);
    index_tau_c = find(tau_c_vector==datCyl(i).tau_c);
    dimension_cyl(index_theta_ign, index_tau_c) = datCyl(i).critical_dimension;
end

% Reshape data in datSlab to matrix of critical dimension
for i = 1:length(datSlab)
    index_theta_ign = find(theta_ign_vector==datSlab(i).theta_ign);
    index_tau_c = find(tau_c_vector==datSlab(i).tau_c);
    dimension_slab(index_theta_ign, index_tau_c) = datSlab(i).critical_dimension;
end

% Compute ratio
matrix_ratio = dimension_cyl ./ dimension_slab;

% Plot
figure(421); clf;
plot(tau_c_vector, matrix_ratio')
set(gca,'XScale','log')
legend(num2str(theta_ign_list));