% Performs probability erf fit via MATLAB curve fitting. Returns fit result
% and goodness of fit

function [fitresult gof] = erf_fit(x,y,seed)
if ~isrow(x)
    x = x';
end
if ~isrow(y)
    y = y';
end
[xData, yData] = prepareCurveData( x, y);

% Set up fittype and options.
ft = fittype( '0.5*(erf(a*(x-c))+1)', ...
    'independent', 'x', ...
    'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 -Inf];
if nargin == 2
    opts.StartPoint = [0.562423173425817 0.497429124904177];
else
    opts.StartPoint = [0.562423173425817 seed];
end
% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );