% Cylinder Dirichlet critical diameter analysis, using M=12 N=4
%   Runs made to compare with the open boundary condition cases

NUM_RUNS = 20; % 20
cyl_radius_vector = 2.2:0.05:3;%1.5:0.07:2.2;%1.4:0.05:2;

% Global parameters
param.dt = 5e-3; %1e-3 %5e-4
param.t_max = 6.; % 2 % 2.1
param.T_ign = 0.2;
param.M = 4; % 12
param.N = 4;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);

for j = 1:length(cyl_radius_vector)
    %% Generate random cloud
    param.cyl_radius = cyl_radius_vector(j);
    cyl_radius = param.cyl_radius;
    length_x = cyl_radius*2;
    length_y = cyl_radius*2;
    length_z = cyl_radius*2*10; % Propagation direction
    source_count = round(pi/4*length_x*length_y*length_z);
    param.source_count = source_count;
    % Particle vectors
    for i = 1:NUM_RUNS
        % Console
        disp(['R sample ' num2str(j) '; ensemble ' num2str(i)]);
        r = length_x/2*sqrt(rand(source_count,1));
        th = 2*pi*rand(source_count,1);
        z = length_z * rand(source_count,1);
        data{j,i}.t_ign = 9e9+zeros(source_count,1);
        Q = sortrows([r, th, z, data{j,i}.t_ign], 3);
        data{j,i}.r = Q(:,1);
        data{j,i}.th = Q(:,2);
        data{j,i}.z = Q(:,3);
        data{j,i}.t_ign(1:round(0.1*length(data{j,i}.t_ign))) = 0;
        clear Q;
        t_ign{j,i} = topdown_test_run_chunking(param, data{j,i});
    end
end

%% Processing
for i = 1:size(t_ign,1)
    for j = 1:size(t_ign,2)
        success_matrix(i,j) = max(data{i,j}.z(t_ign{i,j}<1e8)) / ...
            max(data{i,j}.z);
        success_matrix_binary(i,j) = success_matrix(i,j) > 0.9;
    end
end
prop_probability = sum(success_matrix_binary,2) / size(success_matrix_binary,2);

%% Analysis
[xData, yData] = prepareCurveData( cyl_radius_vector, prop_probability');

% Set up fittype and options.
ft = fittype( '0.5*(erf(a*(x-c))+1)', ...
    'independent', 'x', ...
    'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 -Inf];
opts.StartPoint = [0.562423173425817 0.497429124904177];
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
plot( cyl_radius_vector, prop_probability');

diam_crit = fitresult.c*2; % Radius -> diameter
