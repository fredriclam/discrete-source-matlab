% Data source: speed-deficit-2 (load speed-deficit-2-summary)

% all_entries_... : SOLN, split
% _extract: dat[Cyl or Slab], take entry

% Data extraction
Z_slab = [all_entries_slab_avg.Z];
speed_slab = [all_entries_slab_avg.speed_avg];
Z_cyl = [all_entries_cyl_avg.Z];
speed_cyl = [all_entries_cyl_avg.speed_avg];
slab_xi = [slab_extract.xi];
slab_pp = [slab_extract.propagation_probability];
cyl_pp = [cyl_extract.propagation_probability];
cyl_xi = [cyl_extract.xi];

slab_fit = erf_fit(slab_xi, slab_pp);
crit_thickness = slab_fit.c;

cyl_fit = erf_fit(cyl_xi, cyl_pp);
crit_diam = cyl_fit.c;

%% Variant 1
figure(6754); clf;
subplot(2,2,1);
plot(Z_slab([all_entries_slab_avg.success]), ...
    speed_slab([all_entries_slab_avg.success]),'.');
hold on
plot(Z_slab(~[all_entries_slab_avg.success]), ...
    zeros(size(Z_slab(~[all_entries_slab_avg.success]))),'x')
xlabel 'Thickness'
ylabel 'Average propagation velocity'
title 'Slab: \theta_{ign} = 0.2, \tau_c = 1'

subplot(2,2,2);
plot(Z_cyl([all_entries_cyl_avg.success]), ...
    speed_cyl([all_entries_cyl_avg.success]),'.');
hold on
plot(Z_cyl(~[all_entries_cyl_avg.success]), ...
    zeros(size(Z_cyl(~[all_entries_cyl_avg.success]))),'x')
xlabel 'Diameter'
ylabel 'Average propagation velocity'
title 'Cylinder: \theta_{ign} = 0.2, \tau_c = 1'

subplot(2,2,3);
plot(slab_xi, slab_pp, '.');
xlabel 'Thickness'
ylabel 'Propagation probability'

subplot(2,2,4);
plot(cyl_xi, cyl_pp, '.');
xlabel 'Diameter'
ylabel 'Propagation probability'

%% Variant 2
figure(6755); clf;

subplot(2,2,1);
plot(0.5 ./ Z_slab([all_entries_slab_avg.success]), ...
    speed_slab([all_entries_slab_avg.success]),'.');
hold on
plot(0.5 ./ Z_slab(~[all_entries_slab_avg.success]), ...
    zeros(size(Z_slab(~[all_entries_slab_avg.success]))),'x')
line(0.5 ./ [crit_thickness crit_thickness], [0 0.6], ...
    'Color', 'Red', 'LineWidth', 1.5)
xlabel ('$\frac{1}{2t}$', 'interpreter', 'latex', 'FontSize', 18)
ylabel ('Avg propagation velocity', 'interpreter', 'latex', 'FontSize', 18)
title ('Slab: $\theta_{\mathrm{ign}} = 0.2$, $\tau_\mathrm{c} = 10$', ...
    'interpreter', 'latex', 'FontSize', 18)
set(gca,'TickLabelInterpreter', 'latex', 'FontSize', 14);

subplot(2,2,2);
plot(1 ./ Z_cyl([all_entries_cyl_avg.success]), ...
    speed_cyl([all_entries_cyl_avg.success]),'.');
hold on
plot(1 ./ Z_cyl(~[all_entries_cyl_avg.success]), ...
    zeros(size(Z_cyl(~[all_entries_cyl_avg.success]))),'x')
line(1 ./ [crit_diam crit_diam], [0 0.6], ...
    'Color', 'Red', 'LineWidth', 1.5)
xlabel ('$\frac{1}{d}$', 'interpreter', 'latex', 'FontSize', 18)
ylabel ('Avg propagation velocity', 'interpreter', 'latex', 'FontSize', 18)
title ('Cylinder: $\theta_{\mathrm{ign}} = 0.2$, $\tau_\mathrm{c} = 10$', ...
    'interpreter', 'latex', 'FontSize', 18)
set(gca,'TickLabelInterpreter', 'latex', 'FontSize', 14);

subplot(2,2,3);
plot(0.5 ./ slab_xi, slab_pp, '.');
line(0.5 ./ [crit_thickness crit_thickness], [0 1], ...
    'Color', 'Red', 'LineWidth', 1.5)
xlabel ('$\frac{1}{2t}$', 'interpreter', 'latex', 'FontSize', 18)
ylabel ('Propagation probability', 'interpreter', 'latex', 'FontSize', 18)
set(gca,'TickLabelInterpreter', 'latex', 'FontSize', 14);

subplot(2,2,4);
plot(1 ./  cyl_xi, cyl_pp, '.');
line(1 ./ [crit_diam crit_diam], [0 1], ...
    'Color', 'Red', 'LineWidth', 1.5)
xlabel ('$\frac{1}{d}$', 'interpreter', 'latex', 'FontSize', 18)
ylabel ('Propagation probability', 'interpreter', 'latex', 'FontSize', 18)
set(gca,'TickLabelInterpreter', 'latex', 'FontSize', 14);

for k = 1:4
    subplot(2,2,k)
%     xlim([0.06, 0.18])
end

%% Variant 3
figure(6756); clf;
plot_handle_slab = plot(0.5 ./ Z_slab([all_entries_slab_avg.success]), ...
    speed_slab([all_entries_slab_avg.success]),'sb');
hold on
plot(0.5 ./ Z_slab(~[all_entries_slab_avg.success]), ...
    zeros(size(Z_slab(~[all_entries_slab_avg.success]))),'xb')

line(0.5 ./ [crit_thickness crit_thickness], [0 0.6], ...
    'Color', 'Blue', 'LineWidth', 1.5)

plot_handle_cyl = plot(1 ./ Z_cyl([all_entries_cyl_avg.success]), ...
    speed_cyl([all_entries_cyl_avg.success]),'or');
line(1 ./ [crit_diam crit_diam], [0 0.6], ...
    'Color', 'Red', 'LineWidth', 1.5)
plot(1 ./ Z_cyl(~[all_entries_cyl_avg.success]), ...
    zeros(size(Z_cyl(~[all_entries_cyl_avg.success]))),'xr')

xlabel ('$\frac{1}{d}$ or $\frac{1}{2t}$', 'interpreter', 'latex', 'FontSize', 18)
ylabel ('Average propagation velocity', 'interpreter', 'latex', ...
    'FontSize', 18)
set(gca,'TickLabelInterpreter', 'latex','FontSize', 14);

title ('$\theta_{\mathrm{ign}} = 0.2$, $\tau_\mathrm{c} = 10$', ...
    'interpreter', 'latex')

legend([plot_handle_slab, plot_handle_cyl], {'Slab', 'Cylinder'}, ...
    'interpreter', 'latex', 'FontSize', 18);

% xlim([0.06, 0.18])