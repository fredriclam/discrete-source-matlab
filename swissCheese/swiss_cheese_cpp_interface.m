% Imports data from C++ code for "Swiss cheese" percolation model

%% Navigate
% cd 'C:\Users\Fredy\Documents\Visual Studio 2013\Projects\SCNetwork\Release'
cd 'C:\Users\Fredy\Documents\Visual Studio 2013\Projects\SCNX\Release'
% D = dir('*data*.txt');
D = dir('cubic_data_100-10-1x1-1-1x1.5-6.5-100x100_tign0.05+tauc0.txt');
file_name = D.name;
%% Data import
imported_probability_matrix = importdata(file_name);
% Format note (data.txt): row: varies domain height; outside loop: density
density_vector = 1;%linspace(320,640,100);
% domain_height_vector = linspace(0.1,1,40);
domain_height_vector = linspace(0.1,3,100);
% domain_height_vector = linspace(1.5,6.5,100);

%% 1D plot
plot(domain_height_vector, imported_probability_matrix)

%% Parameter space mapping
% Save to new variable -- for reading multiple files manually
% % Collect to new variable
% if ~exist('counter')
%     counter = 1;
% end
% eval(['domain_height_vector' num2str(counter) ' = domain_height_vector;']);
% eval(['density_vector' num2str(counter) ' = density_vector;']);
% eval(['imported_probability_matrix' num2str(counter) ' = imported_probability_matrix;']);
% counter = counter + 1;

% Plot out -- only for parameter space mapping
% surf(domain_height_vector, density_vector, imported_probability_matrix);

% Stitch plots
figure(100);
surf(domain_height_vector1, density_vector1, ...
    imported_probability_matrix1, 'LineStyle', 'None');
hold on
surf(domain_height_vector2, density_vector2, ...
    imported_probability_matrix2, 'LineStyle', 'None');
surf(domain_height_vector3, density_vector3, ...
    imported_probability_matrix3, 'LineStyle', 'None');
surf(domain_height_vector4, density_vector4, ...
    imported_probability_matrix4, 'LineStyle', 'None');
surf(domain_height_vector5, density_vector5, ...
    imported_probability_matrix5, 'LineStyle', 'None');
surf(domain_height_vector6, density_vector6, ...
    imported_probability_matrix6, 'LineStyle', 'None');
surf(domain_height_vector7, density_vector7, ...
    imported_probability_matrix7, 'LineStyle', 'None');
surf(domain_height_vector8, density_vector8, ...
    imported_probability_matrix8, 'LineStyle', 'None');
surf(domain_height_vector9, density_vector9, ...
    imported_probability_matrix9, 'LineStyle', 'None');
surf(domain_height_vector10, density_vector10, ...
    imported_probability_matrix10, 'LineStyle', 'None');
surf(domain_height_vector11, density_vector11, ...
    imported_probability_matrix11, 'LineStyle', 'None');
surf(domain_height_vector12, density_vector12, ...
    imported_probability_matrix12, 'LineStyle', 'None');
surf(domain_height_vector13, density_vector13, ...
    imported_probability_matrix13, 'LineStyle', 'None');
surf(domain_height_vector14, density_vector14, ...
    imported_probability_matrix14, 'LineStyle', 'None');
surf(domain_height_vector15, density_vector15, ...
    imported_probability_matrix15, 'LineStyle', 'None');

% Set specific window for viewing
% xlim([0,2]);
% ylim([632,640]);

%% Erf fit
fitresult = erf_fit(domain_height_vector, imported_probability_matrix);
diam_crit = fitresult.c;