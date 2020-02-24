% index = 58;
% [X, Y] = prepareCurveData(log(S58_trim(index).t), log(S58_trim(index).W));
% ft = fittype( 'poly1' );
% opts = fitoptions( 'Method', 'LinearLeastSquares');
% [fitresult, gof] = fit(...
% X, Y, ft, opts );
% c_matrix = confint(fitresult,0.95)
% ci_low = c_matrix(1,1);
% ci_high = c_matrix(2,1);
% 
% S58_trim(index).ci_low = ci_low;
% S58_trim(index).ci_high = ci_high;