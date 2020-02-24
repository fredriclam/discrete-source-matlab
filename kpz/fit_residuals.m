% Experimental sine fit to the residuals in Q{index}

function fit_residuals(Q, index)
i = index;
if ~(exist('Q','var'))
    error('!');
end

% Get
W = Q{i};
X = W(:,1);
Y = W(:,2);

% Plot
plot(X,Y);

% Fit
xData = X(1:150);
yData = Y(1:150);
ft = fittype( 'sin1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf 0 -Inf];
opts.StartPoint = [1.19076560338761 0.506111765654778 0.420709275222601];
[fitresult, gof] = fit( xData, yData, ft, opts );

a1 = fitresult.a1; %0.1548;
b1 = fitresult.b1; %1.766;
c1 = fitresult.c1; %0.008676;
residuals_fit = @(x) a1 * sin (b1*x + c1);

hold on;
plot(X,residuals_fit(X),'r');
plot(X,Y-residuals_fit(X),'g');