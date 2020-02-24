function [crit_xi, gof_sse] = swiss_cheese_squeeze(xi_range, data_vector)
% Max fraction of data allowed to be zero or one
discard_criterion = 0.75; % 0.5

% Gaussian fit
[xData, yData] = prepareCurveData( ...
    xi_range, data_vector);
ft = fittype( '0.5*erf(a*(x-b))+0.5', ...
    'independent', 'x', 'dependent', 'y' );
% Remove "perfect data"
if sum(yData==ones(size(yData))) > discard_criterion*numel(yData) || ...
    sum(yData==zeros(size(yData))) > discard_criterion*numel(yData)
    crit_xi = NaN;
    gof_sse = NaN;
else
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0 0]; % Limit to positive parameters
    opts.StartPoint = [0.439977606695074 0.716040173315064];
    % Fit model to data
    [fitresult, gof] = fit( xData, yData, ft, opts );
    crit_xi = fitresult.b;
    gof_sse = gof.sse;
end