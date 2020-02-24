% Max fraction of data allowed to be zero or one
discard_criterion = 0.5;

% Cylinder vertical side order: 1 5 3 7 11 9 10 12 13 14 15

density_range = density_vector6;
success_matrix = imported_probability_matrix6;
xi_range = domain_height_vector6;
map_coordinates = [mean(xi_range), mean(density_range)];

% Store critical dimension as function of number density
crit_xi_range = zeros(size(density_range));
% Goodness of fit (sum of squares error)
gof_sse_range = zeros(size(density_range));

for density_index = 1:length(density_range)
    % Gaussian fit
    [xData, yData] = prepareCurveData( ...
        xi_range, success_matrix(density_index,:) );
    ft = fittype( '0.5*erf(a*(x-b))+0.5', ...
        'independent', 'x', 'dependent', 'y' );
    % Remove "perfect data"
    if sum(yData==ones(size(yData))) > discard_criterion*numel(yData) || ...
        sum(yData==zeros(size(yData))) > discard_criterion*numel(yData)
        crit_xi_range(density_index) = NaN;
        gof_sse_range(density_index) = NaN;
        continue
    end
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0 0]; % Limit to positive parameters
    opts.StartPoint = [0.439977606695074 0.716040173315064];
    % Fit model to data
    [fitresult, gof] = fit( xData, yData, ft, opts );
    crit_xi_range(density_index) = fitresult.b;
    gof_sse_range(density_index) = gof.sse;
end

% Plot processed information
figure(101);
plot(density_range,crit_xi_range);
xlabel 'Number density', ylabel '{\xi}_{crit}';
% Plot error
figure(1001);
plot(density_range,gof_sse_range);
xlabel 'Number density', ylabel 'sse error';

% Concatenation filter
if ~exist('data_collector')
    data_collector = [];
end

data_collector = [data_collector; [density_range', crit_xi_range']];

%% Backup data_collector
data_collector_original = data_collector;

%% Post-process data_collector

% Remove NaNs
data_collector(isnan(data_collector(:,1)),:)=[];
data_collector(isnan(data_collector(:,2)),:)=[];

% Count increment in x
stepping_vector = [data_collector(:,1); NaN] - ...
    [NaN; data_collector(:,1)];
stepping_vector = stepping_vector(1:end-1); % Last entry is meaningless
mask = (stepping_vector == 0);
% Shift mask to remove lower value (should have lower precision)
mask = [mask(2:end); 0]';
% Remove entries
data_collector(mask==1,:) = [];

%% Plot processed data
processed_number_density = data_collector(:,1);
processed_crit_xi = data_collector(:,2);

plot(data_collector(:,1), data_collector(:,2),'.');
xlabel 'Number density'
ylabel '\xi_{crit}'