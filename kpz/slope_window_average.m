% Calculates slope using a window and centre of interval used for linear
% regression.
% 
% Takes a set of data in t-space and extracts loglog slope information
% using windows of size specified. Returns slope over the range of
% information, and the corresponding ln(t) values around which the slope
% measurement is centred. Uses standard linear regression methods.
% 
% Input
%     input_x: input x vector
%     input_y: input y vector
%     window_size: window size (data points in total to use in a window)
% Output
%     output_x: ln(t) at the centre of the interval over which slope is
%         calculated
%     output_y: slope calculated over the interval centred at the
%         corresponding ln (t) value
%
% See also slope_window_spectrum (caller), ensemble_convergence_spectrum,
% extract_average (called), extract_common_mean_width.

function [output_x, output_y] = slope_window_average(input_x, input_y,...
    window_size)

% Allocate vectors for output: x is the instantaneous centre of the
% interval over which linear regression is performed; y is the slope
% measured over the same interval
output_x = zeros(length(input_x)-window_size,1);
output_y = output_x;

% For each "window" or sub-interval of x in the data
for j = 1:length(output_x)
    % Find lower index to read from the total data
    lower_index = j;
    % (Safety) bring up to first index if out of bounds
    if lower_index < 1
        lower_index = 1;
        warning('A');
    end
    % Find upper index to read from the total data
    upper_index = j + window_size - 1;
    % (Safety) bring back to last index if out of bounds
    if upper_index > length(input_x)
        upper_index = length(input_x);
        warning('B');
    end
    
    % Take window of log data (slice)
    slice_vector_x = input_x(lower_index:upper_index);
    slice_vector_y = input_y(lower_index:upper_index);
    
    % Set up fittype and options for regression
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    % Use robust fitting
    %         opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult{2}, gof(2)] = fit(...
        slice_vector_x, slice_vector_y, ft, opts );
    % Get slope
    output_y(j) = fitresult{2}.p1;
    % Write centre value of x to windowed_x
    output_x(j) = (input_x(lower_index) + input_x(upper_index))/2;
end