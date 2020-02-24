% Generate KPZ Map <CTM fig 6>

% Write r2
% Qx = Q76;
% for i = 1:length(Qx)
%     ft = fittype( 'poly1' );
%     opts = fitoptions( 'Method', 'LinearLeastSquares');
%     [fitresult, gof] = fit(...
%         log(Qx(i).t), log(Qx(i).W), ft, opts );
%     % Get slope
%     Qx(i).r2 = gof.rsquare;
%     Qx(i).beta_raw = fitresult.p1;
% end
% Save to specific variable

% Data path
Q = Q76;

% Map:
% Map parameters
beta_error = 0.12; % beta within this fraction error
r2_crit = 0.99; % r^2 > this
marker_size = 13;
hack_factor = 1e-3; % Treat tauc = 0 as this instead
max_deficit = 0.05; % Max velocity deficit (%)

% Hack tauc = 0 case
for i = 1:length(Q)
    if Q(i).tauc == 0
        Q(i).tauc = hack_factor;
    end
end

% Initialization
cat1 = []; % KPZ category
cat2 = []; % Nonlinear beta = 1/3
cat3 = []; % Linear non 1/3
cat4 = []; % Non KPZ

% Categorize parameter cases
for i = 1:length(Q)
    % Choose parameters
    beta = Q(i).beta;
    r2 = Q(i).r2_corrected;
    if abs(beta - 1/3)/(1/3) < beta_error
        if r2 > r2_crit
            cat1 = [cat1 i];
        else
            cat2 = [cat2 i];
        end
    else
        if r2 > r2_crit
            cat3 = [cat3 i];
        else
            cat4 = [cat4 i];
        end
    end
end

% Generate map
figure(2); clf;
if ~isempty(cat1)
semilogy([Q(cat1).tign], [Q(cat1).tauc],...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',marker_size,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
end
hold on
if ~isempty(cat2)
semilogy([Q(cat2).tign], [Q(cat2).tauc],...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',marker_size,...
    'Marker','<',...
    'LineStyle','none',...
    'Color',[1 1 1]);
end
if ~isempty(cat3)
semilogy([Q(cat3).tign], [Q(cat3).tauc],...
    'MarkerFaceColor',[0 1 0],...
    'MarkerSize',marker_size,...
    'Marker','v',...
    'LineStyle','none',...
    'Color',[1 1 1]);
end
if ~isempty(cat4)
semilogy([Q(cat4).tign], [Q(cat4).tauc],...
    'MarkerFaceColor',[0 0 0],...
    'MarkerSize',3,...
    'Marker','x',...
    'LineWidth',13,...
    'LineStyle', 'none',...
    'Color',[0 0 0]);
end
% Add legend
legend({'\beta = 1/3 (KPZ)','\beta = 1/3, initiation effects', ...
    '\beta < 1/3','No power law observed'});
% Comfortable axes
axis([0, 0.5, 0.5e-3, 2e2]);

title(['r^2 < ' num2str(r2_crit) '; \beta = 0.33\pm' ...
    num2str(beta_error*1/3)])

% Some W-scale plot
% figure(3); clf;
% hold on;
% for i = 1:length(Q)
%     W_max = max(Q(i).W(2*end/3:end));
%     scatter(Q(i).tign,Q(i).tauc,1024,W_max,'.');
%     set(gca,...
%         'YScale', 'log')
% end
% colorbar;

xlim([0,0.5]);
set(gca,...
    'xminortick','off',...
    'XTick',0:0.05:0.5,...
    'Xticklabel',{'',0.1,'',0.2,'',0.3,'',0.4,'',0.5},...
    'FontSize', 24,...
    'FontName', 'Times New Roman',...
    'LineWidth', 2.5,...
    'Position', [0.13, 0.11, 0.775, 0.815],...
    'yminortick','on'...
);
set(gcf, 'Units', 'Normalized',...
    'Position', [0. 0., 1.1*0.5 1.1*0.8]);





% Flame speed comparison macro
% Initialization
cat_continuumspeed = []; % Continuum flame speed x%
cat_else = []; % The rest

% Categorize parameter cases
for i = 1:length(Q)
    % Choose parameters
    vd = Q(i).v_deficit;
    if vd <= max_deficit
        cat_continuumspeed = [cat_continuumspeed i];
    else
        cat_else = [cat_else i];
    end
end

% Generate map
figure(3); clf;
if ~isempty(cat_continuumspeed)
semilogy([Q(cat_continuumspeed).tign], [Q(cat_continuumspeed).tauc],...
    'MarkerFaceColor',[0 0 1],...
    'MarkerSize',marker_size,...
    'Marker','o',...
    'LineStyle','none',...
    'Color',[1 1 1]);
end
hold on
if ~isempty(cat_else)
semilogy([Q(cat_else).tign], [Q(cat_else).tauc],...
    'MarkerFaceColor',[1 0 0],...
    'MarkerSize',marker_size,...
    'Marker','<',...
    'LineStyle','none',...
    'Color',[1 1 1]);
end

% Add legend
legend({'Continuum flame speed', 'Else'});
% Comfortable axes
axis([0, 0.5, 0.5e-3, 2e2]);

xlim([0,0.5]);
set(gca,...
    'xminortick','off',...
    'XTick',0:0.05:0.5,...
    'Xticklabel',{'',0.1,'',0.2,'',0.3,'',0.4,'',0.5},...
    'FontSize', 24,...
    'FontName', 'Times New Roman',...
    'LineWidth', 2.5,...
    'Position', [0.13, 0.11, 0.775, 0.815],...
    'yminortick','on'...
);
set(gcf, 'Units', 'Normalized',...
    'Position', [0. 0., 1.1*0.5 1.1*0.8]);