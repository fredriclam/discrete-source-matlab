% Animates the convergence of statistical runs as the number of runs
% increases. Uses the same assumptions as extract_average.
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
%
% Input
%     make_gif (bool, optional): make gif of converging loglog plot?
%     save_figs (bool, optional): save each .fig file for posterity?
%
% See also beta_time, beta_time_backwards, ensemble_convergence.

function ensemble_convergence(make_gif, save_figs)

% Factor by which to expand the axes (appearance of all-runs mosaic plot)
AXIS_FACTOR = 0.5;

if nargin == 0
    make_gif = false;
    save_figs = false;
elseif nargin == 1
    save_figs = false;
end

% Read all the files in
files_vector = dir('*.dat');
if isempty(files_vector)
    warning('No files found here! Returning.');
    return
end
% Sample the data by reading in the first data file
str = files_vector(1).name;
in_package = importdata(str);
% Check type and convert into palatable data
type = whos('in_package');
% Handle data based of sample file based on whether or not there was a
% comment line
if strcmp(type.class,'double')
    data = in_package; % Strip first line from double-type ( zero line )
elseif strcmp(type.class,'struct')
    data = in_package.data;
else
    error('Unknown data type!');
end

% Allocate sum matrix
sum = zeros(size(data,1),size(data,2));

for i = 1:length(files_vector)
    % This block of code is same as extract_average
    % Get i-th file
    str = files_vector(i).name;
    % Grab data
    in_package = importdata(str);
    % Check type and convert into palatable data
    type = whos('in_package');
    % Handle data based of sample file based on whether or not there was a
    % comment line
    if strcmp(type.class,'double')
        data = in_package; % Strip first line from double-type (zero line)
    elseif strcmp(type.class,'struct')
        data = in_package.data;
    else
        error('Unknown data type!');
    end
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
    
    % Activities between each population size
    % Plot all raw data in panel graph
    figure(1);
    subplot(8,10,i);
    plot(data(:,1),data(:,3),'.');
    % Fix axis somewhat naturally
    if i == 1
        % MATLAB auto axes
        axis auto;
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        % Expand axes a bit
        axes_vector = zeros(1,4);
        axes_vector(1) = xlim(1) / (10^AXIS_FACTOR);
        axes_vector(2) = xlim(2) * (10^AXIS_FACTOR);
        axes_vector(3) = ylim(1) / (10^AXIS_FACTOR);
        axes_vector(4) = ylim(2) * (10^AXIS_FACTOR);
        axis(axes_vector);
    else
        axis(axes_vector);
    end
    % Manual settings
    %     axis([1e-1, 1e3, 1e-1, 1e1]); % all loglogs
    %     axis([1e-1, 35, 1e-1, 1e1]); % tighter settings
    
    % Averaged log-log plot
    figure(2);
    average = sum ./ i;
    loglog(average(:,1),average(:,3),'b');
    
    % Fix axis somewhat naturally
    if i == 1
        % MATLAB auto axes
        axis auto;
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        % Expand axes a bit
        axes_vector = zeros(1,4);
        axes_vector(1) = xlim(1) / (10^AXIS_FACTOR);
        axes_vector(2) = xlim(2) * (10^AXIS_FACTOR);
        axes_vector(3) = ylim(1) / (10^AXIS_FACTOR);
        axes_vector(4) = ylim(2) * (10^AXIS_FACTOR);
        axis(axes_vector);
    else
        axis(axes_vector);
    end
    
    % Add title indicating number of runs
    title([num2str(i) ' runs']);
    % Save every .fig if told to do so
    if save_figs
        savefig(['loglog_runs' num2str(i) '.fig']);
    end
    
    % Generate beta-time plot with current averaged data
    
    
end

% Generate gif
if make_gif
    figToImage('convergence_runs', i, 0.25, true)
end