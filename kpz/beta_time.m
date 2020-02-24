% Deprecated function
%
% Generates data series of slope beta from W, t data with a growing window
% from the left (always includes first data point, range expands towards
% last point).
%
% Input
%     X: linear time (t) data
%     Y: linear width (W) data
% Output
%     output_x: new t vector
%     output_y: slope (beta) vector
%
% See also beta_time_backwards.

function [output_x, output_y] = beta_time(X, Y)

% Generate new t vector (taking slopes => have one less data point)
output_x = X(2:length(X));
% Preallocate for output (slope) vector
output_y = zeros(size(output_x,1),size(output_x,2));

% Calculate slopes for growing window
for i = 2:length(X)
    X_subset = X(1:i);
    Y_subset = Y(1:i);
    % Remove nonsensical data
    [xData, yData] = prepareCurveData( log(X_subset), log(Y_subset));
    % Set up fittype and options.
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult{2}, gof(2)] = fit( xData, yData, ft, opts );
    output_y(i-1) = fitresult{2}.p1;
end

% Trim
% i = 3;
% while i <= length(output_x)
%     % If decreasing element found
%     if abs(output_x(i) - output_x(i-1)) - abs(output_x(i-1) - output_x(i-2)) > 0.1
%         output_x = output_x(1:i-1);
%         output_y = output_y(1:i-1);
%         i = length(output_x) + 2;
%     end
%     i = i + 1;
% end