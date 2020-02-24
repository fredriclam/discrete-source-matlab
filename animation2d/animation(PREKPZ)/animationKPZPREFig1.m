%% Import
% cd 'C:\Users\Fredy\Desktop\Additional Movie'
f_h = fopen('TFLD2_517112116.dat');
C = textscan(f_h, '%f');
fclose(f_h);
Z = C{1};

rawdata = importdata('SOLN2_517112116.dat');
SOLN = rawdata.data;
%% Reshape
x_res = 400+1;
y_res = 400;
% Input problem parameters
width_x = 100;
width_y = 100;
% Auto t_res
t_res = length(Z)/x_res/y_res;
% Reshape the data into paged matrix; access by Z(m,n,T)
TFLD = reshape(Z, [x_res,y_res,t_res]);
% Pre-allocate vectors
x_vector = linspace(0, width_x, x_res);
y_vector = linspace(0, width_y*(1-1/y_res), y_res);

%% Settings
dt = 0.07;
contour_res = 0.01;
caxis_limits = [0, 1.2];

%% Test
figure(85); clf;

i = 700;
time = dt*(i-1);
contourf(x_vector,y_vector,TFLD(:,:,i)',...
    'LineStyle', 'none', 'LevelStep', contour_res);
hold on
% Plot ignited and unignited points
plot(SOLN(SOLN(:,4) <= time, 2), SOLN(SOLN(:,4) <= time, 3), ...
    '.', 'MarkerSize', ...
    8, 'Color', 0.*[0 0 0]);
plot(SOLN(SOLN(:,4) > time, 2), SOLN(SOLN(:,4) > time, 3), ...
    '.', 'MarkerSize', ...
    8, 'Color', 1*[1 1 1]);
% Front
contour(x_vector, y_vector, TFLD(:,:,i)', [0.5 0.5] ,...
    'linecolor', [1 1 1], 'LineWidth', 1*5.5);
contour(x_vector, y_vector, TFLD(:,:,i)', [0.5 0.5] ,...
    'linecolor', [0 0 0], 'LineWidth', 1*2.);


hold off;
% Scale
% xlim([0, 49.5]), ylim([0, 49.5])
curr_xlim = [10, 60]; %%% Note: use centre for 100x100
curr_ylim = [10, 60];
xlim(curr_xlim);
ylim(curr_ylim);

% xlim(curr_xlim);
% ylim(curr_ylim);
daspect([1 1 1]); % pbaspect([1 1 1]);

% Adjust the plot: set contour stuff
colormap hot;
caxis(caxis_limits);

% Mod axes
set(gca, 'FontName', 'Times New Roman', 'FontSize', 32, ...
    'XTick',curr_xlim(1)+(0:10:50),'XTickLabel',0:10:50, ...
    'YTick',curr_ylim(1)+(0:10:50),'YTickLabel',0:10:50, ...
    'TickDir','out', ...
    'XMinorTick', 'On', 'YMinorTIck', 'On', ...
    'LineWidth', 2, ...
    'TickLength',1.7*[0.01, 0.025]);
xlabel '\itx'
ylabel '\ity'
%% Video writer
% Close video writer object if it already exists
try
    close(q_tarantino);
end
figure; set(gcf,'position',[0,100,1000,1000]);
% Create video writer object
q_tarantino = VideoWriter('MovieOutput','MPEG-4');
q_tarantino.set('FrameRate', 20);
open(q_tarantino);

%% Form video
for i = 2:700
    time = dt*(i-1);
    contourf(x_vector,y_vector,TFLD(:,:,i)',...
        'LineStyle', 'none', 'LevelStep', contour_res);
    hold on
    % Plot ignited and unignited points
    plot(SOLN(SOLN(:,4) <= time, 2), SOLN(SOLN(:,4) <= time, 3), ...
        '.', 'MarkerSize', ...
        8, 'Color', 0.*[0 0 0]);
    plot(SOLN(SOLN(:,4) > time, 2), SOLN(SOLN(:,4) > time, 3), ...
        '.', 'MarkerSize', ...
        8, 'Color', 1*[1 1 1]);
    % Front
    contour(x_vector, y_vector, TFLD(:,:,i)', [0.5 0.5] ,...
        'linecolor', [1 1 1], 'LineWidth', 1*5.5);
    contour(x_vector, y_vector, TFLD(:,:,i)', [0.5 0.5] ,...
        'linecolor', [0 0 0], 'LineWidth', 1*2.);
    
    
    hold off;
    % Scale
    curr_xlim = [10, 60]; %%% Note: use centre for 100x100
    curr_ylim = [10, 60];
    xlim(curr_xlim);
    ylim(curr_ylim);

    daspect([1 1 1]); % pbaspect([1 1 1]);
    
    % Adjust the plot: set contour stuff
    colormap hot;
    caxis(caxis_limits);
    
    % Mod axes
    set(gca, 'FontName', 'Times New Roman', 'FontSize', 32, ...
        'XTick',curr_xlim(1)+(0:10:50),'XTickLabel',0:10:50, ...
        'YTick',curr_ylim(1)+(0:10:50),'YTickLabel',0:10:50, ...
        'TickDir','out', ...
        'XMinorTick', 'On', 'YMinorTIck', 'On', ...
        'LineWidth', 2, ...
        'TickLength',1.7*[0.01, 0.025]);
    xlabel '\itx'
    ylabel '\ity'
    writeVideo(q_tarantino, getframe(gcf));
end
close(q_tarantino);