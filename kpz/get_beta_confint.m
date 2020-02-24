% Get overall beta (slope of logW-logt)
work_package = S51;

for i = 1:length(work_package)
    [X, Y] = prepareCurveData(log(work_package(i).t), log(work_package(i).W));
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    % (Don't) use robust fitting
    %         opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult, gof] = fit(...
        X, Y, ft, opts );
    % Get slope
    work_package(i).beta_naive = fitresult.p1;
    ci = confint(fitresult,0.95);
    work_package(i).ci_low = ci(1,1);
    work_package(i).ci_high = ci(2,1);
end