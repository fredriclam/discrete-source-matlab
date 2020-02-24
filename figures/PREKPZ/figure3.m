% Style <CTM fig 3>
% Format for 1-D averaging figure window

% Set stuff in axes
set(gca,'YTickLabel',{'0','','0.4','','0.8','','1.2'},...
    'YTick', 0:0.2:1.2,...
    'YMinorTick','on',...
    'XMinorTick','on',...
    'TickLength',0.02*[1 1/4],...
    'LineWidth',1.2,...
    'FontSize',20,...
    'FontName','Times New Roman');
% Manual axes
xlim(gca,[-40 40]);
ylim(gca,[0 1.2]);

box(gca,'on');
hold(gca,'all');

% Create xlabel
xlabel('\itx','FontSize',36,'FontName','Times');
% Create ylabel
ylabel('{\it\theta}','FontSize',36,'FontName','Times');

% Uniform size
set(gcf, 'units', 'normalized', 'position', [0, 0, 1.6*5/16, 1.6*8/16])

