% Format options

font = 'Times New Roman';
font_size_L = 24;
font_size_S = 12;

xlabel_text = ' t ';
ylabel_text = ' W ';
axis_vector = [0, 26, 0, 5];

legend_labels = {};

% Machinery
try
    close(1);
end
figure(1);
hold ('on');

% Plot
subplot(2,2,1);
axis_vector = [0, 14, 0, 4];
plot(wTign005(:,1),wTign005(:,2),'k.');
cics_format; % Call formatting script
title '{\it{T}}_{ign} = 0.05';

subplot(2,2,2);
axis_vector = [0, 17, 0, 4];
plot(wTign010(:,1),wTign010(:,2),'k.');
cics_format; % Call formatting script
title '{\it{T}}_{ign} = 0.10';

subplot(2,2,3);
axis_vector = [0, 26, 0, 5];
plot(wTign020(:,1),wTign020(:,2),'k.');
cics_format; % Call formatting script
title '{\it{T}}_{ign} = 0.20';

subplot(2,2,4);
axis_vector = [0, 125, 0, 7];
plot(Tign040200x400FrontScaling(:,1),Tign040200x400FrontScaling(:,2),'k.');
cics_format; % Call formatting script
title '{\it{T}}_{ign} = 0.40';