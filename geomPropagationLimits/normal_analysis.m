function [critical_dimension, ci, characteristic_scale]=...
    normal_analysis(prim_dimension, percent_propagated)

% Prepare data
[X, Y] = prepareCurveData(prim_dimension,...
    percent_propagated);
ft = fittype( '0.5*(1+erf(a*(x-b)))',...
    'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares');
% Enforce positive fit parameters
opts.Lower = [0 0]; 
% Arbitary positive starting point
opts.StartPoint = [.5 1];
% Fit
if length(X)<2 || length(Y)<2
    characteristic_scale = NaN;
    critical_dimension = NaN;
    ci = [NaN NaN];
else
[fitresult, gof] = fit(X, Y, ft, opts );
% Extract data and dscales
characteristic_scale = fitresult.a;
critical_dimension = fitresult.b;
ci = confint(fitresult,0.95);
ci = [ci(1,2) ci(2,2)];
end