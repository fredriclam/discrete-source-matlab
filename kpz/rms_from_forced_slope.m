% Experimental
% Calculates rms deviation of the actual W-t data from a linear fit forced
% to have 1/3 slope
% Returns the linear fit forced to have a 1/3 slope

function [y_hat, slope, yint] = rms_from_forced_slope(xData,yData)
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Lower = [1/3 -Inf];
opts.Upper = [1/3 Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );
y_hat = fitresult.p1 * xData + fitresult.p2;
slope = fitresult.p1;
yint = fitresult.p2;