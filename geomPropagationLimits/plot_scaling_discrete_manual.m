% Manually plot the critical diameter values at the discrete limit for
% various cases (DOT PLOT)

% Regular series at tau_c = 0.01
theta_1 = [0.01, 0.025, 0.05, 0.1, 0.2, 0.3];
diam_1 = [1.3947, 1.7252, 2.1684, 2.8590, 4.3322 , 6.4049];

% Super discrete at tau_c = 0.001
theta_2 = 0.005;
diam_2 = 1.5722;

% Isothermal
theta_3 = [0.05, 0.1, 0.2];
diam_3 = [3.0416, 3.8918, 5.0117];

% Overlapping spheres (tauc = 0, theta_ign = 0.005)
theta_4 = 0.005;
diam_4 = 2.4504;

%% Plot all
figure(23476);
clf;
plot_handle{1} = plot(1,diam_1,'.','MarkerSize', 24);
CO = get(gca,'ColorOrder');
hold on

% Isothermal series
for i  = 1:length(theta_3)
    plot_handle{i+1} = plot(2,diam_3(i),'.','MarkerSize', 24, ...
        'Color', CO(i+2,:));
end

% Super small series
plot_handle{5} = plot(4, diam_2, '.k','MarkerSize', 24);

% Equivalent hard sphere
plot_handle{6} = plot(5, diam_4, '.k','MarkerSize', 24);

ylabel '{\itd}_{cr}'
xlim([0.5, 5.5])
ylim([0, 8])
set(gca, 'XTick', [1 2 4 5], ...
    'XTickLabel', {'Open BCs', 'Isothermal', ...
    'Open \theta_{ign}=0.005', 'Swiss cheese'})

legend([plot_handle{1}; plot_handle{5}], {'\theta_{ign} = 0.01', '\theta_{ign} = 0.025', '\theta_{ign} = 0.05', ...})
'\theta_{ign} = 0.1', '\theta_{ign} = 0.2', '\theta_{ign} = 0.3', ...
'\theta_{ign} = 0.005'});
