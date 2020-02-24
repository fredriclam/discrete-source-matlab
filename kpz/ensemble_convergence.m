% Deprecated version for FrontRoughening (B) -- for desktop/laptop runs
% TO DO: SAVE THE LAST FRAME, WOULD BE USEFUL!
%       ALSO, SCALING IS KIND OF CATASTROPHIC (CRAZY VARIANCE)
%       ALSO, FRAME RATE SETTING PARAM
%
% Animates the convergence of statistical runs as the number of runs
% increases. Essentially a plotting wrapper of extract_average, iterated
% over increasing number of runs used. Uses the same input assumptions as
% extract_average.
%     * Figure 1: All runs, W vs. t
%     * Figure 2: Averaged log W vs. log t
%     * Figure 3: Beta vs. time as points are added toward the right (blue)
%     and then as points are removed from the left (red). Essentially a
%     "travelling window" sliding from the left to the right, with size
%     fixed as the total number of data points.
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

function ensemble_convergence(make_beta_time_plot, gif_frame_delay)

if nargin == 0
    make_beta_time_plot = true;
end

if nargin < 2
    gif_frame_delay = 0.05;
end

% Factor by which to expand the axes (appearance of all-runs mosaic plot)
AXIS_FACTOR = 0.5;
% Factor for extended beta-time plot
AXIS_FACTOR_LINEAR = 1.2;
% Figure names
FIG_NAME1 = 'w-t_all_runs';
FIG_NAME2 = 'loglog_runs';
FIG_NAME3 = 'beta_time';

% Controls; but making these false might defeat the purpose of this f'n
make_gif = true;
save_figs = true;

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
        axes_vector_1(1) = xlim(1);% / (10^AXIS_FACTOR);
        axes_vector_1(2) = xlim(2);% * (10^AXIS_FACTOR);
        axes_vector_1(3) = ylim(1);% / (10^AXIS_FACTOR);
        axes_vector_1(4) = ylim(2);% * (10^AXIS_FACTOR);
        axis(axes_vector_1);
    else
        axis(axes_vector_1);
    end
    % Manual settings
    %     axis([1e-1, 1e3, 1e-1, 1e1]); % all loglogs
    %     axis([1e-1, 35, 1e-1, 1e1]); % tighter settings
    
    % Averaged log-log plot
    figure(2);
    % Extract current average
    [current_average_x, current_average_y] = extract_average(i);
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
        axes_vector_2(2) = xlim(2) * (10^(AXIS_FACTOR/2));
        axes_vector_2(3) = ylim(1) / (10^AXIS_FACTOR);
        axes_vector_2(4) = ylim(2) * (10^(AXIS_FACTOR/2));
        axis(axes_vector_2);
    else
        axis(axes_vector_2);
    end
    % Add title indicating number of runs
    title([num2str(i) ' runs']);
    % Save every .fig if told to do so
    if save_figs
        savefig([FIG_NAME2 num2str(i) '.fig']);
    end
    
    if make_beta_time_plot
        % Generate beta-time plot with current averaged data
        figure(3);
        cla(3);
        [x_b, y_b] = beta_time_backwards(current_average_x, current_average_y);
        [x_f, y_f] = beta_time(current_average_x, current_average_y);
        hold on;
        % Combine forward and backward in one continuous line
        combined_current_average_y = [y_f; y_b];
        plot(combined_current_average_y,'r.');
        plot(combined_current_average_y(1:length(x_f)),'b.');
        % Natural axis fit
        if i == 1
            % MATLAB auto axes
            axis auto;
            xlim = get(gca, 'XLim');
            ylim = get(gca, 'YLim');
            % Expand axes a bit
            axes_vector_3 = zeros(1,4);
            axes_vector_3(1) = xlim(1);
            axes_vector_3(2) = xlim(2) * AXIS_FACTOR_LINEAR;
            axes_vector_3(3) = 0;
            axes_vector_3(4) = 0.6;
            axis(axes_vector_3);
            
            %     title([str 'm{\it{\theta}}_{ign}'], 'FontName',...
            %         'Times New Roman', 'FontSize', 14);
            xlabel '~Data points';
            ylabel '\beta';
        else
            axis(axes_vector_3);
        end
        legend({'Removing Points', 'Adding Points'}, 'Location', 'North');
        % Add title indicating number of runs
        title([num2str(i) ' runs']);
        % Save every .fig if told to do so
        drawnow;
        if save_figs
            savefig([FIG_NAME3 num2str(i) '.fig']);
        end
    end
end

% Generate gif 1
if make_gif
    fig_to_image(FIG_NAME2, i, gif_frame_delay, true)
end
% Generate gif 2
if make_beta_time_plot && make_gif
    fig_to_image(FIG_NAME3, i, gif_frame_delay, true)
end
% Save runs sheet (W-t)
if save_figs
    savefig(figure(1), [FIG_NAME1 '.fig']);
end