% Calculates regular RMS width from all RMSW files in current folder. The
% h-bar used here is from the individual runs only. Requires RMSW and HOFY
% files in current directory.
%
% Input
%     num_samples (optional): number of samples to use. Defaults to ALL
% Output
%     output_x: linear-spaced t vector
%     output_y: linear-spaced W vector
%
% See also extract_common_mean_width, slope_window_spectrum, 
% ensemble_convergence_spectrum, ensemble_conv_everything; and deprecated:
% beta_time, beta_time_backwards, ensemble_convergence.

function [output_x,output_y] = extract_average(num_samples)

if nargin == 0
    num_samples = -1;
end

% Get list of all RMSW files in current directory
files_vector = dir('RMSW*.dat');
if isempty(files_vector)
    error('NO DATA ''RMSW*.dat''');
end
% Sample first file
str = files_vector(1).name;

data = importdata(str);
% % Grab all the data from the first (sample) file
% in_package = importdata(str);
% % Check type and convert into palatable data
% type = whos('in_package');
% % Handle data based of sample file based on whether or not there was a
% % comment line
% if strcmp(type.class,'double')
%     data = in_package; % Strip first line from double-type ( zero line )
% elseif strcmp(type.class,'struct')
%     data = in_package.data;
% else
%     error('Unknown data type!');
% end

% Allocate sum matrix
sum = zeros(size(data,1),size(data,2));

% Assign loop limit
if num_samples == -1
    loop_limit = length(files_vector);
else
    loop_limit = num_samples;
end
    
% Loop for all files in current directory
counter = 1;
for i = 1:loop_limit
    % Get i-th file
    str = files_vector(i).name;
%     % Grab data
%     in_package = importdata(str);
%     % Check type and convert into palatable data
%     type = whos('in_package');
%     % Handle data based of sample file based on whether or not there was a
%     % comment line
%     if strcmp(type.class,'double')
%         data = in_package; % Strip first line from double-type (zero line)
%     elseif strcmp(type.class,'struct')
%         data = in_package.data;
%     else
%         error('Unknown data type!');
%     end

data = importdata(str);
    
    % Generate padding with zeros if the input data ended early
    if size(data,1) < size(sum,1)
        % Create new temp matrix the size of the summation matrix
        temp = zeros(size(sum,1),size(sum,2));
        % Pop data into temp matrix as submatrix
        temp(1:size(data,1), 1:size(data,2)) = data;
        % Swap matrix;
        data = temp;
    end
    
    % Sum data to sum matrix
    sum = sum + data;
    
    % Increment counter
    counter = counter + 1;
end

% Average
average = sum ./ counter;

% Extract data to the two output vectors
output_x = (average(:,1)); output_y = (average(:,3));

% % Trim off anomalous x affected by different sampling sizes
% i = 3; % Assuming the data is large enough, starting at element 3 is OK
% while i <= length(output_x)
%     % If decreasing element found
%     if abs(output_x(i) - output_x(i-1)) - abs(output_x(i-1) - output_x(i-2)) > 0.1
%         % Trim both x and y
%         output_x = output_x(1:i-1);
%         output_y = output_y(1:i-1);
%         % Make sure loop exits
%         i = length(output_x) + 1337;
%     end
%     % Increment counter
%     i = i + 1;
% end

% % Trim off any drop-off at end of data
% i = length(output_x);
% while i >= 2
%     % Keep trimming until increase finally detected
%     if output_y(i) > output_y(i-1)
%         break
%     else
%         % Trim both x and y
%         output_x = output_x(1:i-1);
%         output_y = output_y(1:i-1);
%     end
%     i = i - 1;
% end

% % Filter all non-finite numbers and NaNs
% i = 1;
% while i < length(output_x)
%     % Delete i-th element where infinity or negative value is found: x or y
%     if ~(  output_x(i) < Inf && output_x(i) > 0 && output_y(i) < Inf && output_y(i) > 0  )
%         output_x(i) = [];
%         output_y(i) = [];
%     else
%         % Increment counter only if nothing was deleted
%         i = i + 1;
%     end
% end

% Keep only up to the highest legal index: search for the highest legal
% index of the data to use, querying all HOFY data files in current
% directory
hli = highest_legal_index;
% Take only up to the highest legal index
output_x = output_x(1:hli);
output_y = output_y(1:hli);

% Obsolete comments for usage with old version for laptop and desktop usage
% Extracts average data from ALL '.dat' files in the current folder under
% the following assumptions:
%     * Comment lines are stripped
%     * If there is no comment line, the first line is deleted (the way it
%     started was the first line had t = 0, W = 0 for certain settings...
%     which is definitely not great, but it's this way for consistency)
%     * All files otherwise have the same sampling resolution and the
%     following format: first column = t, second column = averaged front
%     position, third column = W (RMS width)
% Data is filtered according to the following procedures:
%     * Since data should be linearly spaced along the x-axis (t), if a
%     spacing clearly not conforming to the linear spacing is detected, the
%     data is chopped off there
%     * The drop-off at the end of the data in W is chopped off
%     (attributable to finite-size effects)
%     * Negative values, NaNs and Infinite values of W are removed
