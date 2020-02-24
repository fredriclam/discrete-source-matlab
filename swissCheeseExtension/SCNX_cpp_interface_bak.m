% Imports data from C++ code for "Swiss cheese" percolation model

%% Navigate
% cd 'C:\Users\Fredy\Documents\Visual Studio 2013\Projects\SCNX\Release'

%% Specify independent variables
% CYLINDER
% domain_height_vector = linspace(0.1,6,20); % 0.01
% domain_height_vector = linspace(0.1,6,20); % 0.025
% domain_height_vector = linspace(1,7,20); % 0.05
% domain_height_vector = linspace(8,24,50); % 0.1
% domain_height_vector = linspace(8,24,50); % 0.2

% SLAB
% domain_height_vector = linspace(0.1,2,20); % 0.01
% domain_height_vector = linspace(0.1,2,20); % 0.025
% domain_height_vector = linspace(0.1,3,20); % 0.05
% domain_height_vector = linspace(0.1,4,100); % 0.1
% domain_height_vector = linspace(0.1,4,100); % 0.2 --

MAX_ORDER = 9;

%% Nth order data
INDEX = 3;

figure(3457); clf;
diam_crit = zeros(1,MAX_ORDER+1);
imported_probability_matrix = {};
for n = 0:MAX_ORDER
    D = dir(['SCNX_data_deg' num2str(n) '*']);
    file_name = D.name;
    imported_probability_matrix{n+1} = importdata(file_name);
    
    summation_probability = imported_probability_matrix{1};
    for m = 2:n+1
        summation_probability = summation_probability + ...
            imported_probability_matrix{m};
    end
    
    plot(domain_height_vector, summation_probability);
    if n == 0
        hold on;
    end
    
    fitresult = erf_fit(domain_height_vector, ...
        summation_probability);
    % Seed erf_fit with 15 for TIGN = 0.1, CYL.
    diam_crit(n+1) = fitresult.c;
end
diam_crit_matrix(INDEX,:) = diam_crit;
%% Plot
% load "comparisonWithFullModel.mat"

% Hint: diam_crit_matrix_slab = diam_crit_matrix;
first_N_cases = 3;

figure(2350); clf;
plot(theta_ign_vector(1:first_N_cases), ...
    crit_diam_full_model(1:first_N_cases), 'o', ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [1 0 0])
hold on;
plot(theta_ign_vector(1:first_N_cases), diam_crit_matrix_cyl,'.')
xlabel ('$\theta_\mathrm{ign}$','interpreter','latex','fontsize', 24)
ylabel ('$d_\mathrm{cr}$','interpreter','latex','fontsize', 24)
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 18)
set(gcf, 'position', [680, 463, 720, 520]);
xlim([0, 0.12])
set(gca,'TickLength',1.5*[0.01, 0.025],'LineWidth', 1.2)

figure(2351); clf;
plot(theta_ign_vector(1:first_N_cases), ...
    crit_thickness_full_model(1:first_N_cases), 's', ...
    'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', [0 0 1])
hold on;
plot(theta_ign_vector(1:first_N_cases), diam_crit_matrix_slab,'.')
xlabel ('$\theta_\mathrm{ign}$','interpreter','latex','fontsize', 24)
ylabel ('$t_\mathrm{cr}$','interpreter','latex','fontsize', 24)
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 18)
set(gcf, 'position', [680, 463, 720, 520]);
xlim([0, 0.12])
set(gca,'TickLength',1.5*[0.01, 0.025],'LineWidth', 1.2)