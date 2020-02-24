% Mysterious get chi function

function chi = get_chi(t, l, W)
chi = zeros(1,length(t));
for i = 1:length(t)
    W_vector = W(:,i);
    logW = log(W_vector);
    logl = log(l);
    
    if isrow(logW)
        logW = logW';
    end
    if isrow(logl)
        logl = logl';
    end
    
    disp(size(logW));
    disp(size(logl));
    
    [logl, logW] = prepareCurveData(logl, logW);
    
    % Everywhere slope
    ft = fittype( 'poly1' );
    opts  = fitoptions( 'Method', 'LinearLeastSquares');
    fitresult = fit(logl, logW, ft, opts );
    
    slope = fitresult.p1;
    chi(i) = slope;
end