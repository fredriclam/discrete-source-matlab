% Adjusts plot's appearance to make it ever so slightly more readable.
%
% Input
%     xaxis (string, optional): x-axis name
%     yaxis (string, optional): y-axis name
%     xyticks (2-vector, optional): number of ticks in x and y axes
%       respectively. Defaults to [5 5].
%     flag_minor_ticks (boolean,optional): use minor ticks?

function adjplot(xaxis, yaxis, xyticks, flag_minor_ticks)

if nargin >= 1
    xlabel_handle = xlabel(xaxis);
    set(xlabel_handle,'FontName', 'Times New Roman',...
        'FontSize', 32);
end
if nargin >= 2
    ylabel_handle = ylabel(yaxis);
    set(ylabel_handle,'FontName', 'Times New Roman',...
        'FontSize', 32);
end
if nargin >= 4
    if flag_minor_ticks
        set(gca,'xminortick','on',...
            'yminortick','on');
    end
end

% Set axis font, size
set(gca,'FontName', 'Times New Roman',...
    'FontSize', 24);
% Set x-axis ticks
xlim = get(gca,'XLim');
if nargin >= 3
    set(gca,'XTick',linspace(xlim(1), xlim(2), xyticks(1)));
end
% Set y-axis ticks
ylim = get(gca,'YLim');
if nargin >= 3
    set(gca,'YTick',linspace(ylim(1), ylim(2), xyticks(2)));
end

% % Set minor ticks
% set(gca,'XMinorTick','on');
% set(gca,'YMinorTick','on');
% % Set aspect ratio
% set (gca, 'DataAspectRatio', [1 1 1]);

% % Enforce inside box on
% box on;

% % Set renderer options
% set(1, 'Renderer', 'painters',...
%        'RendererMode', 'manual');