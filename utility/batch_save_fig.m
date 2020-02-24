% Saves a series of figures as both .fig and as .png
%
% Input
%     root (string): Output name of set of figures
%     num_start (optional): First figure number to include
%     num_end: Last figure number to include 

function batch_save_fig(root, num_start, num_end)

% % Handle input arguments
% % if nargin == 2
% %     num_start = 1;
% elseif nargin == 3
% else
%     error('Not enough input arguments.');
% end

% Generate stuff for each figure
for i = num_start:num_end
    str_fig = [root num2str(i) '.fig'];
    str_png = [root num2str(i) '.png'];
    % Check for existence
    if exist (str_fig, 'file') || exist (str_png, 'file')
        error('Figure already exists! Abandon ship!');
    end
    % Generate .fig file
    savefig(figure(i), str_fig);
    % Generate png
    print(figure(i), str_png,'-dpng');
end