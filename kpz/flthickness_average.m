% Converts event-driven first-last thickness data into regularly spaced
% width data. First-last thickness is defined as the distance along the
% direction of flame propagation between the farthest out ignited particle
% and the farthest back unignited particle.
%
% Input
%     dt (optional): dt for sampling event-driven data. Original
%       event-driven data is provided by the C++ code, and contains all the
%       information since thickness recording is event-driven.
% Output
%     average_width: 2 columns: column 1 is t, column 2 is the first-last
%       thickness.

function average_width = flthickness_average (dt)

if nargin == 0
    dt = 0.1;
end

% Check all the file names in current directory
files_vector = dir('MISC*.dat');
% Load first file for parameters
data = load(files_vector(1).name, '-ascii');
% Calculate t_max and number of ticks needed based on first file loaded
t_max = data(size(data,1),1);
n_ticks = floor(t_max/dt);
t_max = dt*floor(t_max/dt);
% Generate regularly spaced data in regular_matrix
regular_matrix = zeros(n_ticks, 2, length(files_vector));

index_of_validity = size(regular_matrix,1);

% Loop over all files in current directory
for i = 1:length(files_vector)
    % Load i-th file
    str = files_vector(i).name;
    data = load(str, '-ascii');
    
    % Start at t = dt (first nontrivial data point)
    t = dt;
    % Indices
    it_read = 1;
    it_write = 1;
    while t <= t_max
        t_check = data(it_read,1);
        while t_check < t
            it_read = it_read + 1;
            if it_read > size(data,1)
                t_check = 2*t;
            else
                t_check = data(it_read,1);
            end
        end
        % Zero out-of-bounds values, and take last datum not exceeding t
        if t_check >= 2*t
            w = 0;
            regular_matrix(it_write,:,i) = [t , w];
            % Check to see if write-iterator if the smallest yet
            % Adjust the index of validity
            if it_write-1 < index_of_validity
                index_of_validity = it_write-1;
            end
            break
        else
            w = data(max([it_read-1,1]),2);
        end
        regular_matrix(it_write,:,i) = [t , w];
        it_write = it_write + 1;
        t = t + dt;
    end
end

% Reduce to average
average_width = zeros(n_ticks, 2);
for i = 1:size(regular_matrix,3)
    average_width = average_width + regular_matrix(:,:,i);
end
average_width = average_width / size(regular_matrix,3);

% Truncate
average_width = average_width(1:index_of_validity,:);

% % Save results
% save('snapped_results.mat')