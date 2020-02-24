set(gcf,'position',[0,100,1000,600]);
set(gca,'FontSize', 24, 'FontName', 'Times New Roman');
xlabel '{\it\tau}_c';

% Manual legend
legend({'{\it\theta}_{ign} = 0.05'
    '{\it\theta}_{ign} = 0.10'
    '{\it\theta}_{ign} = 0.20'
    '{\it\theta}_{ign} = 0.30'}, 'Location', 'EastOutside')
set(gca,'XMinorTick', 'On', 'YMinorTIck', 'On')
set(gca,'TickLength',2*[0.01, 0.025]);
set(gca,'LineWidth',1)
%% Cylinder
xlim([1e-2, 1e2])
ylim([0, 10]);
ylabel '{\itd}_c'

%% Slab
xlim([1e-2, 1e2])
ylim([0, 5]);
ylabel '{\itt}_c'