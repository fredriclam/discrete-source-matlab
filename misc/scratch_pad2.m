% % Get r^2 linearity
Q = all_data;
for i = 1:length(Q)
    [X, Y] = prepareCurveData(log(Q(i).t), log(Q(i).W));
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    % (Don't) use robust fitting
    %         opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult, gof] = fit(...
        X, Y, ft, opts );
    % Get slope
    Q(i).rsquare = gof.rsquare;
end

% Plot beta, r^2 map
for i = 1:length(Q)
    if i == 1
        figure(77);
        clf;
    end
    plot(Q(i).beta, Q(i).rsquare,...
        '.',...
        'Color', get_rainbow_colour(i, length(Q)),...
        'MarkerSize', 32);
    if i == 1
        hold on
    end
end
xlabel '\it\beta'
ylabel '{\itR}^2'

%% Plot specified range in W-t and logW-logt from Q64
% i_range = [1,21, 24, 27, 37, 47, 58];
% 
% i_start = i_range(1);
% i_end = i_range(end);
% figure(1); clf;
% 
% for i = i_range
%     subplot(1,2,1);
%     plot(Q64(i).t,Q64(i).W,...
%         'Color', get_rainbow_colour(i-i_start+1, i_end-i_start+1));
%     if i == i_start
%         hold on
%     elseif i == i_end
%         adjplot('\itt','\itW')
%     end
%     subplot(1,2,2);
%     plot(log(Q64(i).t),log(Q64(i).W),...
%         'Color', get_rainbow_colour(i-i_start+1, i_end-i_start+1));
%     if i == i_start
%         hold on
%     elseif i == i_end
%             adjplot('ln\itt','ln\itW')
%     end
% end

%% Plot for ICTAM
t = Q64patch(34).t;
W = Q64patch(34).W;

loglog  = true;

if ~loglog
    % Plain
    plot(t,W,'r','LineWidth',3);
else
    % Loglog
    plot(log10(t),log10(W),'r','LineWidth',3);
end

if ~loglog
    xlabel ('\itt','FontSize', 24);
    ylabel ('\itW','FontSize', 24);
else
    xlabel ('log_{10} \itt','FontSize', 24);
    ylabel ('log_{10} \itW','FontSize', 24);
end

set(gca,'YMinorTick','on');
set(gca,'XMinorTick','on');
set(gca,...
    'FontSize', 24,...
    'LineWidth', 2)
if ~loglog
    xlim([0, 50]);
    ylim ([0,5]);
else
xlim([-1,1.5]);
ylim([-0.5,1]);
line([0,0.6],[0,0],'LineWidth', 1.5,'Color',[0 0 0]);
line([0.6,0.6],[0,0.2],'LineWidth', 1.5,'Color',[0 0 0]);
line([0,0.6],[0,0.2],'LineWidth', 1.5,'Color',[0 0 0]);
set(gca,'DataAspectRatio',[1 1 1]);
end

% % Additional plot code (log)
% plot(log10(Q64patch(35).t),log10(Q64patch(35).W),'r','LineWidth',3)
% % Nonlog:
% plot(Q64patch(35).t,Q64patch(35).W,'r','LineWidth',3)