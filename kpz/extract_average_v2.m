% Calculates local-mean (mean calculated within each run) RMS width from
% all data files in current folder.
% 
% This version also cuts off the beginning until at least 200 particles
% were ignited.
% 
% Requires HOFY, MISC, and RMSW files in current directory, and assumes
% that these files correspond to the same set of runs.
% 
% Does not save anything.
%
% Input
%     num_samples (optional): number of samples to use. Defaults to ALL
% Output
%     output_t: linear-spaced t vector
%     output_x: linear-spaced <h> (spatial average of front position)
%         vector corresponding to output_t
%     output_N: linear-spaced N (number of particles ignited) vector
%         corresponding to output_t
%     output_W: linear-spaced W vector corresponding to output_t
%
% See also extract_common_mean_width, slope_window_spectrum, 
% ensemble_convergence_spectrum, ensemble_conv_everything; and deprecated:
% beta_time, beta_time_backwards, ensemble_convergence.

function [output_t, output_x, output_N, output_W] = ...
    extract_average_v2(num_samples, min_num_ignited)
% Quick dimensions
width_x = 1000;
width_y = 100;

% Set default case of number of samples if not specified
if nargin < 1
    num_samples = -1;
end
% Parameter: number of particles ignited before data is considered valid
% Set default equal to zero (start to include from time zero)
if nargin < 2
    min_num_ignited = 0; % 4000 is initiation number
end
% Get list of all RMSW files in current directory
files_vector = dir('RMSW*.dat');
if isempty(files_vector)
    error('NO DATA ''RMSW*.dat''');
end
% Sample first file for automatic matrix size
str = files_vector(1).name;
data = importdata(str);
% Allocate sum matrix
sum = zeros(size(data,1),size(data,2));
% Assign loop limit
if num_samples == -1
    loop_limit = length(files_vector);
else
    loop_limit = num_samples;
end
% Loop for all files in current directory and sum
for i = 1:loop_limit
    % Get i-th file
    str = files_vector(i).name;
    % Import data
    data = importdata(str);
    % Sum data to sum matrix
    sum = sum + data;
end
% Take average
average = sum ./ loop_limit;
% Extract data to the three output vectors (assumed position)
output_t = average(:,1);
output_x = average(:,2);
output_W = average(:,3);
% Reuse variable sum as a counter
preallocate_size = 0.9*width_x*width_x;
sum = zeros(preallocate_size,1);
% Grab all MISC files
D = dir('MISC*.dat');
if isempty(D)
    error('NO DATA ''MISC*.dat''');
end
% Load all files and sum ignition times
for j = 1:length(D)
    file_name = D(j).name;
    data = importdata(file_name);
    
    ignition_times = data(:,1);
    
    % Generate padding with zeros if the input data ended early
    if size(ignition_times,1) < size(sum,1)
        % Create new temp matrix the size of the summation matrix
        temp = zeros(size(sum,1),size(sum,2));
        % Pop data into temp matrix as submatrix
        temp(1:size(ignition_times,1), 1:size(ignition_times,2)) =...
            ignition_times;
        % Swap matrix;
        ignition_times = temp;
    elseif size(ignition_times,1) > size(sum,1)
        % Create new temp matrix the size of the summation matrix
        temp = zeros(size(ignition_times,1),size(ignition_times,2));
        % Pop data into temp matrix as submatrix
        temp(1:size(sum,1), 1:size(sum,2)) =...
            sum;
        % Swap matrix;
        sum = temp;
    end
    
    sum = sum + ignition_times;
end
% Get average vector of ignition times
average_ignition_times = sum ./ length(D);
% Initialize N vector
N = zeros(length(output_t),1);
% Convert time vector to number of particles ignited at that instant
for j = 1:length(output_t)
    N(j) = t_to_num_particles(average_ignition_times, output_t(j));
end
% Output vector of number of particles
output_N = N;
% Compute lowest legal index
lli = find(N >= min_num_ignited,1);
% Keep only up to the highest legal index: search for the highest legal
% index of the data to use, querying all HOFY data files in current
% directory
hli = highest_legal_index(width_x);
% Take data only within the specified bounds of legality
output_t = output_t(lli:hli);
output_x = output_x(lli:hli);
output_N = output_N(lli:hli);
output_W = output_W(lli:hli);