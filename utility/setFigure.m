x_str = 'Number density $\eta_\mathrm{c} = \frac{4}{3} \pi r^3 \frac{N}{L^3}$';
y_str = '$d_{50\%}$ or $t_{50\%}$';

%%
set(gca,'TickLabelInterpreter', 'latex','FontSize', 18);
xlabel (x_str, 'interpreter', 'latex', 'FontSize', 22)
ylabel (y_str, 'interpreter', 'latex', 'FontSize', 22)
set(gcf, 'position', [680, 463, 720, 520]);
set(gca,'TickLength',1.5*[0.01, 0.025],'LineWidth', 1.2)
set(legend,'Interpreter', 'latex');

%% All grid
set(gca,'Xgrid','on')
set(gca,'Xminorgrid','on')
set(gca,'yminorgrid','on')
set(gca,'Ygrid','on')

