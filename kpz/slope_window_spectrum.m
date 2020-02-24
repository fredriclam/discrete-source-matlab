% Generate spectrum graph of slopes over different window sizes.
%
% Plots (using figure 3) the spectrum graph. The so-called spectrum graph
% plots the slope vs. ln(t) using different "window sizes" for linear
% regression. The window sizes chosen are taken from a log-spaced range
% from 20 to 240. The function tries to choose the number of window sizes
% to try specified, but guarantees to use <= that number of window sizes.
%
% * To read the graph: colour cycle from red to purple-ish. The hotter the
% colour (and the longer the curve) the smaller the window used (see
% legend for size of window in # of data points used in window). The colder
% the colour, the larger the window. End points of each curve are shown in
% a heavy dot. The series of heavy dots represent growing windows attached
% to the left- and right- most data points. Thus, the left half of the
% heavy dots show incremental window sizes including always the left data
% points, while the right half of the heavy dots show decremental window
% sizes including always the rightmost data point.
% 
% The middle value of everything is the slope of almost all the data
% points.
% 
% Sets automatic max window size equal to 96% of the vector length (e.g.
% 250 -> set max size 240) and minimum equal to 20.
%
% Overwrites existing 'spectrum.fig'
%
% Input:
%     num_lines: Number of curves to plot (i.e. number of window sizes to
%         try)
%     fn (optional): Function to use for extracting the average
%       Choices are:
%         extract_average_v2 (default)
%         extract_common_mean_width
%     save_flag (optional): Save .fig or not (default: true)
%
% See also: slope_window_average, ensemble_convergence_spectrum,
% extract_average, extract_common_mean_width.

function slope_window_spectrum(fn, save_flag, num_lines)

if nargin < 1
    fn = @extract_average_v2;
end
if nargin < 2
    save_flag = true;
end
if nargin < 3
    num_lines = 50;
end

% Extract average data in current directory
[average_x, ~, ~, average_y] = fn();
% Take ln
log_x = log(average_x);
log_y = log(average_y);

% Set min window size and max window size
min_window_size = 20;
max_window_size = floor(0.96*length(log_x));

% Window sizes to use
candidates = floor(logspace(...
    log10(min_window_size), log10(max_window_size), num_lines));
% Remove duplicate entries
i = 1;
while i < length(candidates)
    if candidates(i) == candidates(i+1);
        candidates(i+1) = [];
    else
        i = i + 1;
    end
end
% Get number of unique window sizes
num_candidates = length(candidates);
% Build legend entries
labels = cell(1,length(candidates));
for i = 1:length(candidates)
    labels{i} = num2str(candidates(i));
end

% Use figure 3
figure(3); clf;
hold on;
% Allocate vector for plot curve handles
curve_handles = zeros(1,num_candidates);

% For each window size
for i = 1:num_candidates
    % Extract averaged log-log (ln-ln actually) slope data
    [t, beta] = slope_window_average(log_x, log_y, candidates(i));
    % Get current colour in cycle
    colour_vector = get_rainbow_colour(i,num_candidates);
    % Plot curves
    curve_handles(i) = plot(t, beta,'Color', colour_vector);
    % Plot end nodes
    plot(t(1), beta(1), '.',...
        'Color', colour_vector,...
        'MarkerSize', 24);
    plot(t(length(t)), beta(length(t)), '.', ...
        'Color', colour_vector,...
        'MarkerSize', 24);
    drawnow;
end

% Plop legend
l = legend(curve_handles, labels, 'Location', 'EastOutside');
% % Set x outer position to just outside plot on the right
% pos = get(l, 'OuterPosition');
% pos(1) = 0.9;
% set(l, 'OuterPosition', pos);
% Change axis
axis tight;
set(gca,'YLim',[0, 0.5]);
% Tidy up axes fonts
adjplot('ln \it{t}','\it{\beta}', [4 6]);
set(gca, 'yminortick', 'on');
% % Save figure
if save_flag
    savefig('spectrum.fig');
end