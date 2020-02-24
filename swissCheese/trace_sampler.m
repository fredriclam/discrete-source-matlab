% Assume success_matrix, density_range, xi_range

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
    if isequal(yData,ones(size(yData)))
        crit_xi_range(density_index) = NaN;
        gof_sse_range(density_index) = 0;
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

