% Animate boxcar function as tau_c decreases

figure;
tau_c_range = 1:-0.005:0.01;

% Create video writer object
m_bay = VideoWriter('MovieOutput','MPEG-4');
m_bay.set('FrameRate', 30);
open(m_bay);

for i = 1:length(tau_c_range)
    set(gcf,'Color','w')
    tau_c = tau_c_range(i);
    plot([-0.2, 0, 0, tau_c, tau_c, 1.2], ...
        [0, 0, 1/tau_c, 1/tau_c, 0, 0], 'r', 'LineWidth', 2)
    xlim([-0.05, 1.05]);
    ylim([-1, 10]);
    set(gca, 'XTick', [0 1], ...
        'XTickLabel', {}, 'YTickLabel', {}, ...
        'XMinorTick', 'On', 'TickDir', 'Out', ...
        'TickLength', [0.02, 0.1], ...
        'YTick', [0 10] , 'YGrid', 'On', 'XGrid', 'On',...
        'YMinorGrid', 'On', 'XMinorGrid', 'On', 'LineWidth', 1.);
    writeVideo(m_bay, getframe(gcf));
end
close(m_bay);
disp('Done');