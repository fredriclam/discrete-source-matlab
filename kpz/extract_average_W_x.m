% Deprecated (transitional version)
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

function [output_t, output_x, output_W] = extract_average_W_x(num_samples)

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

% Extract data to the three output vectors
output_t = average(:,1);
output_x = average(:,2);
output_W = average(:,3);

% Keep only up to the highest legal index: search for the highest legal
% index of the data to use, querying all HOFY data files in current
% directory
hli = highest_legal_index;
% Take only up to the highest legal index
output_t = output_t(1:hli);
output_x = output_x(1:hli);
output_W = output_W(1:hli);
