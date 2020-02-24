% Ensemble convergence properties of RMSW (RMS using average h position
% within one run only) with spectrum graph generation.
%
% Animates the convergence of statistical runs as the number of runs
% increases. Essentially a plotting wrapper of extract_average_v2, iterated
% over increasing number of runs used. Uses the same input assumptions as
% extract_average_v2. This function then calls slope_window_spectrum to
% generate a "spectrum graph" of slope beta vs. t.
%
% Generates the following:
%     * Figure 1: All (120) runs, W vs. t (.fig)
%     * Figure 2: Averaged log W vs. log t. (.fig for each frame and .gif)
%     * Figure 3: Spectrum plot for all 120 runs (.fig)
% 
% For HPC runs, the format is:
%     250 samples, log-spaced from t = 0.01 to 90% of end-time of RMS width
%     RMSW files have the following format: first column = t, second column
%      = averaged front position, third column = W (RMS width).
%
% Data filtration is handled by the average-value extraction functions.
%
% See also extract_average_v2, extract_common_mean_width,
% slope_window_spectrum (calls slope_window_average), strand_plot. Also:
% (deprecated) extract_average

function ensemble_convergence_spectrum()

% Frame delay
gif_frame_delay = 0.05;
% Factor by which to expand the axes (appearance of all-runs mosaic plot)
AXIS_FACTOR = 1; % exponent 10^this
% Figure names
FIG_NAME1 = 'w-t_all_runs';
FIG_NAME2 = 'loglog_runs';

% Read all the RMSW files in
files_vector = dir('RMSW*.dat');
if isempty(files_vector)
    warning('No files found here!');
    return
end
% Sample the data by reading in the first data file
str = files_vector(1).name;
data = importdata(str);
% Allocate sum matrix
sum = zeros(size(data,1),size(data,2));
for i = 1:length(files_vector)
    % This block of code is same as extract_average
    % Get i-th file
    str = files_vector(i).name;
    % Grab data
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
    
    % Activities between each population size:
    % Plot all raw data in panel graph
    figure(1);
    subplot(10,12,i);
    plot(data(:,1),data(:,3),'.');
    % Fix axis somewhat naturally
    if i == 1
        % MATLAB auto axes
        axis auto;
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        % Expand axes a bit
        axes_vector_1 = zeros(1,4);
        axes_vector_1(1) = xlim(1);
        axes_vector_1(2) = xlim(2);
        axes_vector_1(3) = ylim(1);
        axes_vector_1(4) = ylim(2)*2;
        axis(axes_vector_1);
    else
        axis(axes_vector_1);
    end
    
    % Averaged log-log plot
    figure(2);
    % Extract current average
    [current_average_x, ~, ~,current_average_y] = extract_average_v2(i);
    % Plot on loglog plot
    plot(log10(current_average_x),log10(current_average_y),'b');
    % Fix axis somewhat naturally
    if i == 1
        % MATLAB auto axes
        axis auto;
        xlim = get(gca, 'XLim');
        ylim = get(gca, 'YLim');
        % Expand axes a bit
        axes_vector_2 = zeros(1,4);
        axes_vector_2(1) = xlim(1) / (10^AXIS_FACTOR);
        axes_vector_2(2) = xlim(2) * (10^(AXIS_FACTOR/4));
        axes_vector_2(3) = ylim(1) / (10^AXIS_FACTOR);
        axes_vector_2(4) = ylim(2) * (10^(AXIS_FACTOR/2));
        axis(axes_vector_2);
    else
        axis(axes_vector_2);
    end
    % Add title indicating number of runs
    title([num2str(i) ' runs']);
    % Save every .fig if told to do so
    savefig([FIG_NAME2 num2str(i) '.fig']);
end

% Generate gif 1
fig_to_image(FIG_NAME2, i, gif_frame_delay, true)
% Save runs sheet (W-t)
savefig(figure(1), [FIG_NAME1 '.fig']);

% Run slope_window_spectrum
slope_window_spectrum();