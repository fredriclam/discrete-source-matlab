% Scratch pad

%% For every folder (clean)
% 
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Action code
%         
%         % Jump out of folder
%         cd ..
%     end
% end

%% Isothermal cylinder heat difference tomographic plot
% % Plot slices of tomographic plot (difference data)
% % File: cylinder_difference_data
% 
% % Axis settings
% axis_setting = [-0.6, 0];
% for i = 1:11
%     subplot(2,6,i);
%     contourf(y_range,x_range,tome(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.005);
%     set(gca, 'DataAspectRatio', [1 1 1]);
%     caxis (axis_setting);
%     colormap bone;
%     %     colorbar
% end

%% Isothermal cylinder heat tomographic plot

% % Plot slices of tomographic plot
% % File: cylinder_data / cylinder_difference_data
% 
% % Axis settings
% % axis_setting = [0, 0.1]; % Standard
% axis_setting = [0, 0.01]; % Over-expose
% for i = 1:11
%     subplot(2,6,i);
%     contourf(y_range,x_range,tome(:,:,i),...
%         'LineStyle', 'none', 'LevelStep', 0.0005);
%     set(gca, 'DataAspectRatio', [1 1 1]);
%     caxis (axis_setting);
%     colormap hot;
%     %     colorbar
% end


%% For every folder structure
% 
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Code
%         if strcmp(D(i).name, '2DCLOUD200x200 TIGN0400TAUC0000')
%             fig_to_image('beta_time',70,0.1,true);
%         else
%             fig_to_image('beta_time',20,0.25,true);
%         end
%         
%         % Jump out of folder
%         cd ..
%     end
% end

%% All folders loop
% list = {'0025', '0050', '0100', '0200', '0250', '0300', '0350', '0400'};
% for str = list
%     % Convert from cell array to string
%     str = char(str);
%     cd (['Ensemble Convergence TIGN' str 'TAUC0000']);
%     str = ['AVG' num2str(str)];
%     str = ['[' str '.x, ' str '.y] = extract_average()'];
%     eval(str);
%     cd ..;
% end

%% Plot beta-time
% ensemble_convergence;
% beta_time;

%% Extract data en-masse (for folder Ensemble Convergence)
% % Extract the average data to struct labeled by initial value of str
% list = {'0025', '0050', '0100', '0200', '0250', '0300', '0350', '0400'};
% for str = list
%     % Convert from cell array to string
%     str = char(str);
%     cd (['Ensemble Convergence TIGN' str 'TAUC000']);
%     str = ['AVG' num2str(str)];
%     str = ['[' str '.x, ' str '.y] = extract_average()'];
%     eval(str);
%     cd ..;
% end
% % Unfold struct
% L = who;
% for i = 1:8
%     str = char(L(i));
%     label = str(4:length(str));
%     var_x = ['x' label];
%     var_y = ['y' label];
%     str = [var_x, ' = ', char(L(i)), '.x; ' , var_y, ' = ', char(L(i)), '.y; '];
%     eval(str);
% end
% % Self-destruct useless variables
% clear ('str', 'var_x', 'var_y', 'label', 'L', 'i', 'list');

%% Plot all data ensembles on one plot

% Plot everything on one plot with random point colour (pretty messy)
% figure(1);
% hold on;
% L = who;
% for i = 1:8
%     eval(['plot (' char(L(i)) '.x, ' char(L(i)) '.y, ''.'', ''Color'', [' num2str([rand,rand,rand]) ']);']);
% end
% axis auto

%% Red and blue window plot: forward beta and backward beta
% list = {'0025', '0050', '0100', '0200', '0250', '0300', '0350', '0400'};
% i = 1;
% for str = list
%     str = char(str);
%     x_var = ['x' str];
%     y_var = ['y' str];
%     [x_b, y_b] = beta_time_backwards(eval(x_var), eval(y_var));
%     [x_f, y_f] = beta_time(eval(x_var), eval(y_var));
%     figure(i); hold on;
%     % Combine forward and backward in one continuous line
%     combo = [y_f; y_b];
%     plot(combo,'r.');
%     plot(combo(1:length(x_f)),'b.');
% %     plot(x_f, y_f, 'b.'); plot(x_b, y_b, 'r.');
%     axis auto;
%     L = legend({'Removing Points', 'Adding Points'}, 'Location', 'North');
%     title([str 'm{\it{\theta}}_{ign}'], 'FontName', 'Times New Roman', 'FontSize', 14);
%     set(gca, 'YLim', [0, 0.5]);
%     xlabel '~Data points'
%     ylabel '\beta'
%     adjplot;
% 
%     i = i + 1;
% end

%% Data sheet
%  for generating error bar plot of beta vs time from bisquare
% regression over entire loglog domain for each TIGN case (TAUC = 0)

% % TIGN, beta (p1), p1 L, p1 U
% data = [...
%     0.025, 0.3284, 0.3245, 0.3323; ...
%     0.05, 0.2932, 0.282, 0.3044; ...
%     0.10, 0.3143, 0.3054, 0.3233; ...
%     0.20, 0.2878, 0.2775, 0.2981; ...
%     0.25, 0.3062, 0.2964, 0.316; ...
%     0.30, 0.2233, 0.2153, 0.2314; ...
%     0.35, 0.253, 0.2469, 0.259; ...
%     0.40, 0.2201, 0.2157, 0.2244 ...
%     ];
% % TIGN, beta(p1), err L, err U
% data(:,3) = data(:,3) - data(:,2);
% data(:,4) = data(:,4) - data(:,2);
% errorbar(data(:,1), data(:,2), data(:,3), data(:,4), 'x');

%% % Generate loglog plot data
% [x, y] = extract_average;
% logx = log(x);
% logy = log(y);

%% % Rename in all subdir
% % All subdirectories
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Code
%         if length(dir) > 2
%             movefile('window10to250.fig','spectrum.fig');
%         end
%         % Jump out of folder
%         cd ..
%     end
% end

%% Open all spectrum graphs
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Code
%         if exist('spectrum.fig')
%             open('spectrum.fig');
%         end
%         % Jump out of folder
%         cd ..
%     end
% end

%% Loop through all 16 open figures
i = 1;
while 1
    figure(i)
    i = i + 1;
    if i == 17
        i = 1;
    end
    pause
end

%% Deprecated read loop

% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         
%         [x y] = extract_average;
%         QQ{i-2} = [x,y];
%         
%         % Jump out of folder
%         cd ..
%     end
% end

%% Plot resiudals
% for i = 1:16
%     hold on
%     obj = all_data{i};
%     obj2 = Q{i};
%     
%     natural_t = obj(:,1);
%     natural_W = obj(:,2);
%     curve_fit_t = exp(obj2(:,1)); % should be equal to natural_t near eps
%     curve_fit_W = exp(obj2(:,2));  
%     
%     linear_residual = natural_W - curve_fit_W;
%     
% %     plot(natural_t, natural_W, 'Color', get_rainbow_colour(i,16));
%     plot(natural_t, curve_fit_W, 'Color', get_rainbow_colour(i,16));
%     plot(natural_t, linear_residual, 'Color', get_rainbow_colour(i,16));
% %     plot(curve_fit_t, curve_fit_W, '.k');
% end
% 
% adjplot('\it t', '\it W');

%% Plot all residual plots
% 
% figure(777);
% low = 1;
% high = 16; % high = length(Q);
% for i = low:high
%     hold on;
%     obj = Q{i};
% %     2: linear
%         plot(obj(:,1), obj(:,2), '-',...
%             'Color', get_rainbow_colour(i,high-low+1));
% %     3: residual
%         plot(obj(:,1), obj(:,3), '-',...
%             'Color', get_rainbow_colour(i,high-low+1));
%     
% end
% axis tight;
% adjplot('ln\it t','ln\it W');
% hold off;
% 
% figure(7777);
% for i = low:high
%     hold on;
%     obj = Q{i};
%     % % 2: linear
%     %     plot(obj(:,1), obj(:,2), '-',...
%     %         'Color', get_rainbow_colour(i,high-low+1));
%     % % 3: residual
%     %     plot(obj(:,1), obj(:,3), '-',...
%     %         'Color', get_rainbow_colour(i,high-low+1));
%     % Residuals in scaled W-t space
%     plot(exp(obj(:,1)) ./ max(exp(obj(:,1))), exp(obj(:,3)), '-',...
%         'Color', get_rainbow_colour(i,high-low+1));
% end
% axis tight;
% adjplot('~ t','Residual \Delta W');
% hold off;

%% Generate plot of both individual RMS and common-mean RMS
% [x1, y1] = extract_average;
% [x2 ,y2] = extract_common_mean_width;
%
% figure(1); clf;
% hold on;
% plot(x1,y1, 'b');
% plot(x2,y2, 'r');
% legend({'Local','Global'});
% adjplot('\it{t}','\it{W}');

%% Build spectrum graphs
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Action code
%         slope_window_spectrum(@extract_average,false,50);
%         % Save figure
%         savefig('spectrum.fig');
%         
%         slope_window_spectrum(@extract_common_mean_width,false,50);
%         % Save figure
%         savefig('spectrum_common_mean_width.fig');
%         
%         % Jump out of folder
%         cd ..
%     end
% end

%% Plot exact flame solution ?? Not sure
% plotting_x_vector = linspace(-15,115,1000);
% exact_y_vector = plotting_x_vector;
% for i = 1:length(plotting_x_vector)
%     exact_y_vector(i) = exact_flame_solution(plotting_x_vector(i), 0.8, 100);
% end
% plot(plotting_x_vector, exact_y_vector, 'k');

% %3D graph for nonuniform_data 
% http://blogs.mathworks.com/videos/2007/11/02/advanced-matlab-surface-plot
% -of-nonuniform-data/
% x=rand(100,1)*16-8;
% y=rand(100,1)*16-8;
% r=sqrt(x.^2+y.^2)+eps;
% z=sin(r)./r;
% %
% xlin=linspace(min(x),max(x),33);
% ylin=linspace(min(y),max(y),33);
% [X,Y]=meshgrid(xlin,ylin);
% Z=griddata(x,y,z,X,Y,’cubic’);
% %
% mesh(X,Y,Z); % interpolated
% axis tight; hold on
% plot3(x,y,z,’.’,’MarkerSize’,15)
% %%surf(X,Y,Z)

%% Chi plots
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Code
%         [t_vector, l_vector, W_matrix] = make_Wtl_plot;
%         savefig(11,'W_of_t_l.fig');
%         savefig(12,'lnW_of_lnt_lnl.fig');
%         savefig(13,'dW_dt_first_order_diff.fig');
%         savefig(14,'dW_dl_first_order_diff.fig');
%         chi_vector = get_chi(t_vector, l_vector, W_matrix);
%         figure(15);
%         plot(t_vector,chi_vector);
%         x_str = '\itl';
%         y_str = '\chi';
%         xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
%         ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
%         adjplot;
%         savefig(15,'chi_regression.fig');
%         % Jump out of folder
%         cd ..
%     end
% end


%% Open all spectrum graphs
% D = dir;
% for i = 1:length(D)
%     if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
%         % Jump in folder
%         cd (D(i).name)
%         
%         % Code
% %         if exist('spectrum.fig')
%             open('spectrum.fig');
% %             open('spectrum_common_mean_width.fig');
% %         end
%         % Jump out of folder
%         cd ..
%     end
% end

%% Generate batch deletion script
% string = [];
% 
% for i = 11615247:11615247+88
%     string = [string, 'qdel ', num2str(i), '\n'];
% end
% 
% %qdel 1904880
% %qdel 1904969


%% Plot all in cell array P
% figure(1); clf; hold on;
% figure(2); clf;
% for i = 1:length(P)
%     data = P{i};
%     N = data(:,1);
%     W = data(:,2);
%     figure(1);
%     plot(N, W, 'Color', get_rainbow_colour(i,length(P)));
%     figure(2);
%     loglog(N, W, 'Color', get_rainbow_colour(i,length(P)));
%     if i == 1
%         hold on;
%     end
% end

% % Garb
% % primary_axes_pos = get(gca,'Position'); % position of first axes
% % ax2 = axes('Position',primary_axes_pos,...
% %     'XAxisLocation','top',...
% %     'YAxisLocation','right',...
% %     'Color','none');

% % Plot W vs t, x , and N
% try
%     close(1)
% catch
% end
% % figure(1);
% % hold on;
% scale = @(q) (q-min(q))/(max(q)-min(q));
% 
% figure(1);
% loglog((t),W,'b');
% figure(2);
% loglog((x),W,'r');
% figure(3);
% loglog((N),W,'g');
% 
% legend({'t','x','N'});

%% Selective plotting
% i_begin = 8; % 8
% i_end = 27; % 27
% for i = i_begin:i_end
% %     plot(all_data(i).t,...
% %         all_data(i).W,...
% %         'Color',...
% %         get_rainbow_colour(i,i_end-i_begin+1));
%     plot(log(all_data(i).t),...
%         log(all_data(i).W),...
%         'Color',...
%         get_rainbow_colour(i,i_end-i_begin+1));
%     
%     if i == i_begin
%         hold on;
%     end
% end
% 
% adjplot;
% legend({all_data(i_begin:i_end).label});

%% Slice
% xs = logx(85:length(logx));
% ys = logy(85:length(logy));

%% Save series
% T_SERIES = {};
% T_SERIES{1} = [log(x_T0425), log(y_T0425)];
% T_SERIES{2} = [log(x_T0450), log(y_T0450)];
% T_SERIES{3} = [log(x_T0475x), log(y_T0475x)];
% T_SERIES{4} = [log(x_T0500), log(y_T0500)];
% 
% J0025_SERIES = {};
% J0025_SERIES{1} = [log(x_JJJA0025), log(y_JJJA0025)];
% J0025_SERIES{2} = [log(x_JJAJ0025), log(y_JJAJ0025)];
% J0025_SERIES{3} = [log(x_JAJJ0025), log(y_JAJJ0025)];
% 
% J0200_SERIES = {};
% J0200_SERIES{1} = [log(x_JJJA0200), log(y_JJJA0200)];
% J0200_SERIES{2} = [log(x_JJAJ0200), log(y_JJAJ0200)];

%% Plot series
% figure(75);
% SERIES = T_ORIGINAL_DATA;
% for i = 1:length(SERIES)
%     plot(SERIES{i}(:,1), SERIES{i}(:,2),...
%         'Color', get_rainbow_colour(i, length(SERIES)));
%     if i == 1
%         hold on;
%     end
% end
% adjplot('\itN','\itW');
% % plot([-5, 5], 0.3333*[-5, 5],':k'); % Reference line
% legend({'0.1:0.025 (\tau:\theta)','1:0.025','10:0.025','0.1:0.2','1:0.2'});

%% Experimental rms_deviation from power curve calculation
% result = zeros(1,28);
% for i = 1:length(all_data)
%     [W_hat, slope, yint] = rms_from_forced_slope(log(all_data(i).t),...
%         log(all_data(i).W));
%     power_curve_fit = exp(yint) * all_data(i).t .^ slope;
%     rms_deviation = (power_curve_fit-all_data(i).W).^2;
%     rms_deviation = sqrt(mean(rms_deviation));
%     result(i) = rms_deviation;
% end

% %% Robustness testing
% WINDOW_SAMPLES = 25;
% window_ratios = linspace(0.1,1,WINDOW_SAMPLES);
% result = zeros(28,WINDOW_SAMPLES);
%
% for i = 9:28
%     input_x = log(all_data(i).t);
%     input_y = log(all_data(i).W);
%     num_elements = length(all_data(i).t);
%     window_sizes = floor(num_elements*window_ratios);
%     for j = 1:length(window_sizes)
%         window_size = window_sizes(j);
%         % Slice
%         slice_x = input_x(1:window_size);
%         slice_y = input_y(1:window_size);
%
%         ft = fittype( 'poly1' );
%         opts = fitoptions( 'Method', 'LinearLeastSquares');
%         [fitresult, ~] = fit(slice_x, slice_y, ft, opts);
%         result(i,j) = fitresult.p1;
%     end
% end
%
% surf(window_ratios, 1:28 ,result)
% adjplot('Window proportion','Test Case'); zlabel '\beta'

%% Read flt, rflt data
% try
% close(1)
% end
% i_begin = 16;
% i_end = 21;
% SCALE_BASE = exp(1);
% for i = i_begin:i_end
%     sel = all_data(i);
%     flt = sel.flt; % everything from flt
%     t = sel.t;
%     N = sel.N;
%     W = sel.W;
%     % expression
%     rt = flt(1:find(flt(:,1)>max(t)-1,1),1); % restricted
%     rflt = flt(1:find(flt(:,1)>max(t)-1,1),2);
%     all_data(i).hli_t_flt = rt;
%     all_data(i).hli_flt = rflt;
%     loglog(rt, SCALE_BASE^i*rflt,':', 'Color', get_rainbow_colour(i-8,i_end));
%     if i == i_begin
%         hold on
%     end
%     loglog(t, SCALE_BASE^i*W/W(1)*rflt(1),'-', 'Color', get_rainbow_colour(i-8,i_end));
% end


%% Remaining quantities Plot
% CASE = 10;
% t = all_data(CASE+8).hli_t_flt;
% flt = all_data(CASE+8).hli_flt;
% clf;
% plot(Q{CASE}(:,1),Q{CASE}(:,3),'g.');
% hold on
% plot(log(t),log(flt),'.');
% plot(log(all_data(CASE+8).t), real(log(all_data(CASE+8).x-20)))
% 
% legend({'log-linear Residuals','FLT','v'})

% figure(99);
% for i = 1:10
%     i_get = i*100-1;
%     jam{i} = sum_W_matrix(i_get,:);
%     plot(t_vector,jam{i},'Color',get_rainbow_colour(i,10));
%     if i == 1
%         hold on
%     end
% end

%% Misc plot
% logts = log(output_t(70:length(output_t)));
% logWs = log(output_W(70:length(output_t)));
% plot(logts, logWs);

%% Mass extraction
% Q = all_data;
% t1 = log(Q(1).t);
% t2 = log(Q(2).t);
% t3 = log(Q(3).t);
% t4 = log(Q(4).t);
% % t5 = log(Q(25).t);
% % t6 = log(Q(26).t);
% % t7 = log(Q(27).t);
% % t8 = log(Q(28).t);
% % t9 = log(Q(29).t);
% 
% W1 = log(Q(1).W);
% W2 = log(Q(2).W);
% W3 = log(Q(3).W);
% W4 = log(Q(4).W);
% % W5 = log(Q(25).W);
% % W6 = log(Q(26).W);
% % W7 = log(Q(27).W);
% % W8 = log(Q(28).W);
% % W9 = log(Q(29).W);

%% Stack
% figure(234);
% plot(t1, W1, '.', 'Color', get_rainbow_colour(1,4));
% hold on;
% plot(t2, W2, '.', 'Color', get_rainbow_colour(2,4));
% plot(t3, W3, '.', 'Color', get_rainbow_colour(3,4));
% plot(t4, W4, '.', 'Color', get_rainbow_colour(4,4));
% 
% t = linspace(-3,6,3);
% plot(t, fittedmodel1.p1*t + fittedmodel1.p2, 'Color', get_rainbow_colour(1,4));
% plot(t, fittedmodel2.p1*t + fittedmodel2.p2, 'Color', get_rainbow_colour(2,4));
% plot(t, fittedmodel3.p1*t + fittedmodel3.p2, 'Color', get_rainbow_colour(3,4));
% plot(t, fittedmodel4.p1*t + fittedmodel4.p2, 'Color', get_rainbow_colour(4,4));
% 
% legend({['\tau_c = 0; \beta = ' num2str(fittedmodel1.p1)],...
%     ['\tau_c = 0.1; \beta = ' num2str(fittedmodel2.p1)],...
%     ['\tau_c = 1; \beta = ' num2str(fittedmodel3.p1)],...
%     ['\tau_c = 10; \beta = ' num2str(fittedmodel4.p1)]})

%% Fit model organization
% for i = 1:18
%     var_name_1 = ['fittedmodel' num2str(2*i-1) '.p1'];
%     var_name_2 = ['fittedmodel' num2str(2*i) '.p1'];
% 
%     eval(['slopes_primary(i) = ' var_name_1]);
%     eval(['slopes_secondary(i) = ' var_name_2]);
% end

% %% Plot all W-t's
% for i = 1:length(all_data)
%     fn = @() deal(all_data(i).t, [], [], all_data(i).W);
%     plot(all_data(i).t, all_data(i).W);
%     axis tight;
%     % Replace x-limit
%     xl = get(gca,'XLim');
%     xl(1) = 0;
%     set(gca, 'XLim', xl);
%     % Replace y-limit
%     set(gca,'YLim',[0, 7]);
%     % Tidy up axes fonts
%     adjplot('\it{t}','\it{W}', [4 6], true); 
%     savefig(all_data(i).name);
% end
% 
% % Slideshow W-t
% % Load all
% fig_list = dir('*.fig');
% close all;
% for i = 1:length(fig_list)
% %     figure;
%     open(fig_list(i).name);
%     set(gcf, 'Name',...
%         ['TAUC' num2str(all_data(i).tauc), ...
%         '-TIGN' num2str(all_data(i).tign)]);
%     set(gcf,'units','normalized','position',[0.25,-0.25,1,1]);
%     drawnow;
% end
% % Flip through
% i = 1;
% while 1
%     figure(i);
%     pause;
%     i = i + 1;
%     if i > length(fig_list)
%         i = 1;
%     end
% end
% 
% %% Plot all W-N's
% for i = 1:length(all_data)
%     fn = @() deal(all_data(i).t, [], [], all_data(i).W);
%     plot(all_data(i).N, all_data(i).W);
%     axis tight;
%     % Replace x-limit
%     set(gca, 'XLim', [0, 40000]);
% %     set(gca, 'XTickMode', 'Auto');
%     % Replace y-limit
%     set(gca,'YLim',[0, 7]);
%     % Tidy up axes fonts
%     adjplot('\it{N}','\it{W}', [5 6], true); 
%     savefig(all_data(i).name);
% end
% 
% % Slideshow
% % Load all
% fig_list = dir('*.fig');
% close all;
% for i = 1:length(fig_list)
%     open(fig_list(i).name);
%     % Set window name
%     set(gcf, 'Name',...
%         ['TAUC' num2str(all_data(i).tauc), ...
%         '-TIGN' num2str(all_data(i).tign)]);
%     set(gcf,'units','normalized','position',[0.25,-0.25,1,1]);
%     drawnow;
% end
% % Flip through
% i = 1;
% while 1
%     figure(i);
%     pause;
%     i = i + 1;
%     if i > length(fig_list)
%         i = 1;
%     end
% end
% 
% %% Plot all W-tuf's
% close all;
% % 1. Generate individual plots
% for i = 1:length(all_data)
%     fn = @() deal(all_data(i).t, [], [], all_data(i).W);
%     plot(all_data(i).t *...
%         flame_switch_speed(all_data(i).tign),...
%         all_data(i).W);
%     axis tight;
%     % Replace x-limit
%     xl = get(gca,'XLim');
%     xl(1) = 0;
%     set(gca, 'XLim', xl);
% %     set(gca, 'XTickMode', 'Auto');
%     % Replace y-limit
%     set(gca,'YLim',[0, 7]);
%     % Tidy up axes fonts
%     adjplot('\it{t} \it{u}_f^{continuum}','\it{W}', [5 6], true); 
%     savefig(all_data(i).name);
% end
% % 2. Stacked plot
% figure(666);
% for i = 1:length(all_data)
%     plot(all_data(i).t *...
%         flame_switch_speed(all_data(i).tign),...
%         all_data(i).W,...
%         'Color',...
%         get_rainbow_colour(i,length(all_data)));
%     if i == 1
%         hold on
%     end
% end
% axis tight;
% % Replace x-limit
% xl = get(gca,'XLim');
% xl(1) = 0;
% set(gca, 'XLim', xl);
% %     set(gca, 'XTickMode', 'Auto');
% % Replace y-limit
% set(gca,'YLim',[0, 7]);
% % Tidy up axes fonts
% adjplot('\it{t} {\it{u}}_{\itf}^{continuum}','\it{W}', [5 6], true);
% savefig('ALL.fig');
% for i = 1:length(all_data)
%     labels{i} = ['\tau' num2str(all_data(i).tauc),...
%         ':\theta', num2str(all_data(i).tign)];
% end
% legend(labels, 'Location','EastOutside');
% % 3. Slideshow
% % Load all
% fig_list = dir('*.fig');
% close all;
% for i = 1:length(fig_list)
%     open(fig_list(i).name);
%     % Set window name
%     set(gcf, 'Name',...
%         ['TAUC' num2str(all_data(i).tauc), ...
%         '-TIGN' num2str(all_data(i).tign)]);
%     set(gcf,'units','normalized','position',[0.25,-0.25,1,1]);
%     drawnow;
% end
% % 4. Flip through
% i = 1;
% while 1
%     figure(i);
%     pause;
%     i = i + 1;
%     if i > length(fig_list)
%         i = 1;
%     end
% end

%% Plot some stuff 
% for i = 1:4
%     figure(15);
%     plot(R(i).t, R(i).W,'Color',get_rainbow_colour(i,4));
%     if i == 1
%         hold on;
%     end
%     figure(16);
%     loglog(R(i).t, R(i).W,'Color',get_rainbow_colour(i,4));
%     if i == 1
%         hold on;
%     end
% end

%% Generate theta, tau map for < plots of W, t >
% for i = 1:15
%     % Flip the plot orientation from top-down to bottom-up
%     plot_location = 3*(5-ceil(i/3)) + mod(i-1,3) + 1;
%     subplot(5,3,plot_location);
%     
%     
%     plot(...
%         Q35(20+i).t,...
%         Q35(20+i).W)
%     titlestr = [...
%         '\theta = ' num2str(Q35(20+i).tign) ...
%         ', \tau_c = ' num2str(Q35(20+i).tauc)];
%     title(titlestr);
% end
% clear i;

%% Generate spread W-t plots for different l (l: colour)
% Loading LONGT0025_comparison_all.mat
% for i = 1:15
%     figure(15);
%     W_of_t = sum_W_matrix(i,:);
%     plot(log(t_vector), log(W_of_t), ...
%         'Color', get_rainbow_colour(i, 15));
%     if i == 1
%         hold on
%     end
%     labels{i} = ['l = ' num2str(lind_vector(i)/10)];
% end
% legend(labels);
% xlabel 'ln \itt'
% ylabel 'ln \itW'
% title (['\theta = 0.025, \tau_c = 0: 1000 long by 100 wide. ' ...
%     'Single Run.' ...
%     '"Statistical balancing" applied.']);

%% Plot R7: driving conditions (initiation densities)
% manual_label = {'0.5', '1', '2', '3', '4'};
% map = [4, 3, 5, 6, 7];
% for i = 1:5
%     index = map(i);
%     plot(log(R7(index).t), log(R7(index).W),...
%         'Color', get_rainbow_colour(i,5));
%     if i == 1
%         hold on
%     end
%     labels{i} = ['\Omega_{equivalent} = ' manual_label{i}];
% end
% legend(labels);
% xlabel 'ln \itt'
% ylabel 'ln \itW'
% title (['\theta = 0.4, \tau_c = 0: 200 long by 200 wide. ' ...
%     'Ensemble of < 120 runs.']);
% 
% % Add on slope reference
% x = [-3, 5];
% slope = 0.467562891408298;
% yint = -0.085112099830229;
% y = slope*x + yint;
% % plot(x, y, ':');

%% Plot all betas in scatter (naive beta)
% theta_list = zeros(1,35);
% tauc_list = zeros(1,35);
% beta_list = zeros(1,35);
% for i = 1:35
%     theta_list(i) = Q35(i).tign;
%     tauc_list(i) = Q35(i).tauc;
%     beta_list(i) = Q35(i).beta;
%     scatter3(theta_list,tauc_list, beta_list, 100, beta_list, 'filled');
% end

%% MS2 Export accidental rename fiasco 
% Remove '.' and '..'
% D = dir;
% i = 1;
% while i <= length(D)
%     if strcmp(D(i).name, '.') || strcmp(D(i).name,'..') || ~D(i).isdir
%         D(i) = [];
%     else
%         i = i + 1;
%     end
% end
% 
% % For each
% for i = 1:length(D)
%     str = D(i).name;
%     id = str(end-2:end);
%     id = str2num(id);
%     if id < 201
%         title = 'JAJJ0250';
%     elseif id < 216
%         title = 'JJJA0300';
%     elseif id < 231
%         title = 'JJAJ0300';
%     elseif id < 246
%         title = 'JAJJ0300';
%     elseif id < 261
%         title = 'AJJJ0300';
%     elseif id < 276
%         title = 'JJJA0350';
%     elseif id < 291
%         title = 'JJAJ0350';
%     elseif id < 306
%         title = 'JAJJ0350';
%     else
%         error 'wtf'
%     end
%     title = [title '_' num2str(id)];
%     disp(title);
% end

%% r^2 patching: removing front data tail, updating r^2
% Q = Q64;
% i_range = 41:64;
% 
% % By batches send to curve-fitting
% for i = i_range
%     cftool(log10(Q(i).t),log10(Q(i).W));
% end
% 
% j_range = [25, 27, 28, 29, 30, 31, 32 33 34 37 38 39 40];
% j_range2 = [41 42 47 48 49 50 51 52];
% for j = j_range2
%     eval(['Q64p(j).r2 = fittedmodel' num2str(j) '.p1;']);
% end

%% Linear filter
% % Prescribed dt
% t = Q64patch(1).t;
% W = Q64patch(1).W;
% dt = 0.01;
% steps = floor(max(t)/dt);
% 
% t_out = zeros(steps,1);
% W_out = zeros(steps,1);
% for i = 1:steps
%     search_index = find(t>=i*dt,1);
%     if isempty(search_index)
%        break; 
%     end
%     t_out(i) = t(search_index);
%     W_out(i) = W(search_index);
% end
% 
% % Plot
% figure(3);
% plot(t_out,W_out,'.')
