% Draft version.
%   FIX ME! I'M INCORRECT! also fix the edge (left edge) case
%
% Animates the convergence of statistical runs as the number of runs
% increases, using . Essentially a plotting wrapper of extract_average, iterated
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
%     max_window: maximum window size
%
% See also beta_time, beta_time_backwards, ensemble_convergence.

function ensemble_convergence_window(max_window_size)

% Factor by which to expand the axes (appearance of all-runs mosaic plot)
AXIS_FACTOR = 0.5;
% Factor for extended beta-time plot
AXIS_FACTOR_LINEAR = 1.2;
% Figure names
FIG_NAME = ['beta_time_window_size_' num2str(max_window_size) '_'];

% Controls; but making these false might defeat the purpose of this f'n
make_gif = true; % make_gif = false;%%
save_figs = true; % save_figs = false;%%

% Window calculations
% Balance, but favour forward data (best practice: use odd number size)
down_step = floor((max_window_size-1)/2);
up_step = ceil((max_window_size-1)/2);

files_vector = dir('*.dat');

for i = 1:length(files_vector)
    % Extract current average
    [current_average_x, current_average_y] = extract_average(i);
    current_log_x = log(current_average_x);
    current_log_y = log(current_average_y);
    
    % Allocate vector
    windowed_x = zeros(length(current_log_x)-max_window_size,1);
    windowed_y = windowed_x;
    % Slice vector
    for j = 1:length(windowed_x)
        % Find upper index to read from the total data
        upper_index = j + up_step;
        % Bring back to last index if out of bounds
        if upper_index > length(current_log_x)
            upper_index = length(current_log_x);
        end
        
        % Find lower index to read from the total date
        lower_index = j - down_step;
        % Bring up to first index if out of bounds
        if lower_index < 1
            lower_index = 1;
        end

        % Take subset of the data (slice)
        slice_vector_x = current_log_x(lower_index:upper_index);
        slice_vector_y = current_log_y(lower_index:upper_index);
        
        % Set up fittype and options.
        ft = fittype( 'poly1' );
        opts = fitoptions( 'Method', 'LinearLeastSquares');
        % Use robust fitting
%         opts.Robust = 'Bisquare';
        % Fit model to data.
        [fitresult{2}, gof(2)] = fit(...
            slice_vector_x, slice_vector_y, ft, opts );
        windowed_y(j) = fitresult{2}.p1;
    end
    
    % Generate beta-time plot with current averaged data
    figure(3);
    cla(3);
    
    hold on;
    % Combine forward and backward in one continuous line
    plot(windowed_y,'b.');
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
    % Add title indicating number of runs
    title([num2str(i) ' runs']);
    % Save every .fig if told to do so
    drawnow;
    if save_figs
        savefig([FIG_NAME num2str(i) '.fig']);
    end
end

% Generate gif 1
if make_gif
    fig_to_image(FIG_NAME, i, 0.2, true)
end