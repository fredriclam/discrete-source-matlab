for I = 2:81
    zeroPt = find(All_x{I}>0,1);
    
    windowRadius = 20;
    x = All_x{I}(zeroPt-2*windowRadius:zeroPt+windowRadius);
    y = All_theta{I}(zeroPt-2*windowRadius:zeroPt+windowRadius)';
    plot(x,y)
    if I == 2
        hold on
    end
    
    % Gaussian fit
    [X, Y] = prepareCurveData( ...
        x, y);
    ft = fittype( '0.5*erf(a*(x-b))+0.5', ...
        'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
%     opts.Lower = [0 0]; % Limit to positive parameters
    opts.StartPoint = [0.439977606695074 0.716040173315064];
    % Fit model to data
    [fitresult, gof] = fit( X, Y, ft, opts );
%     crit_xi = fitresult.b;
%     gof_sse = gof.sse;
    frontThickness(I) = 2/abs(fitresult.a);
end