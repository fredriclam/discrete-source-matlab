% Calculates common-mean RMS width from all HOFY files in current folder
% 
% Returns a vector for t, and a vector for the corresponding common-mean
% RMS width: here, the mean h is calculated using all of the files in the
% current subdirectory, and the RMS is calculated using the same mean h
% (function of t).
%
% Assumes same number of data points for each file within one case (all 
% same format). This is CRUCIAL, since this code takes the mean of means,
% which is only the mean of the individual elements if each subgroup has
% the same weight (same number of elements).
% Assumes 1 node on RMS post-processing lattice (e.g. 201x200 lines for a
% grid of 200x200).
%
% Output
%     t: column vector; taken from the first file loaded
%     RMSW: column vector; common mean RMS width
%
% See also: extract_average, slope_window_spectrum, 
% ensemble_convergence_spectrum, ensemble_conv_everything

function [t, RMSW] = extract_common_mean_width()
% Transverse width
L = 200;

% Get all files named 'HOFY ... .dat'
D = dir('HOFY*.dat');
if isempty(D)
    error('NO DATA ''HOFY*.dat''');
end
% Extract the common (global) mean position of the front over all such
% files
for n = 1:length(D)
    % Load in the file
    str = D(n).name;
    data = importdata(str);
    % Get t-vector: assumed same for all in one case
    t = data(:,1);
    % Construct y-vector (transverse coordinate)
    %     y = 1:1:L;
    
    % Strip first col from data (which is the variable t) and store in
    % matrix h
    h = data(:,2:size(data,2));
    
    % Sum in vector h_bar
    if n==1
        h_bar_sum = mean(h,2);
    else
        h_bar_sum = h_bar_sum + mean(h,2);
    end
end
% Get global mean (vector with elements corresponding to different times
% prescribed by vector t)
global_mean_h = h_bar_sum / length(D);

% Generate sync-averaged RMS, with local
% % Reduce data matrix to mean, stripping first col (t)
% local_mean_h = mean(data(:,2:size(data,2)),2);
% % Generate cookie-cutter matrix to vector-subtract the mean
% cookie_cutter_global = zeros(size(data,1),size(data,2));
% cookie_cutter_local = zeros(size(data,1),size(data,2));
% for j = 2:size(data,2)
%     cookie_cutter_global(:,j) = global_mean_h;
%     cookie_cutter_local(:,j) = local_mean_h;
% end

% Generate cookie-cutter for vector subtraction for RMS width: essentially
% the global mean vector duplicated side-by-side to subtract all elements
% of a data matrix at once
cookie_cutter_global = zeros(size(data,1),size(data,2));
for j = 2:size(data,2)
    cookie_cutter_global(:,j) = global_mean_h;
end

% Start to calculate the common-mean RMS width
total_sum = 0;
for n = 1:length(D)
    % Load file
    str = D(n).name;
    data = importdata(str);
    % Submatrix of h - <h> entries, where <h> is the GLOBAL h
    delta_h_submatrix = data - cookie_cutter_global;
    % Strip first column (in variable t)
    delta_h_submatrix = delta_h_submatrix(:,2:size(data,2));
    % Square each element
    delta_h_submatrix = delta_h_submatrix.^2;
    % Reduce submatrix to sum
    rr = mean(delta_h_submatrix,2);
    % Add vector to total sum
    total_sum = total_sum + rr;
end
% Get final answer
RMSW = sqrt(total_sum ./ length(D));

% Keep only up to the highest legal index: search for the highest legal
% index of the data to use, querying all HOFY data files in current
% directory
hli = highest_legal_index;
% Take only up to the highest legal index
t = t(1:hli);
RMSW = RMSW(1:hli);