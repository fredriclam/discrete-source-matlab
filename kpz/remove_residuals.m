% Returns residuals (Q) cell array: contains all 16 run cases, where each
% case is a m x 2 array ([logx, linear, residual]).

function output = remove_residuals
D = dir;
for i = 1:length(D)
    if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..')
        % Jump in folder
        cd (D(i).name)
        
        [logx, linear,  residuals] = remove_residuals_core(i-2);
        output{i-2} = [logx, linear,  residuals];
        
        % Jump out of folder
        cd ..
    end
end

% LOOP_PERIOD = 16;
% i = 1;
% while 1
%     figure(i)
%     i = i + 1;
%     if i == LOOP_PERIOD+1
%         i = 1;
%     end
%     pause
% end

function [logx, linear, residual] = remove_residuals_core(i)
[x, y] = extract_average;
logx = log(x);
logy = log(y);

ft = fittype( 'poly1' );
opts  = fitoptions( 'Method', 'LinearLeastSquares');
fitresult = fit(logx, logy, ft, opts );

slope = fitresult.p1;
yint = fitresult.p2;

linear = slope * logx + yint;
residual = logy-linear;
disp(i);
% fit = 0.15*sin(pi/2*logx);

% % Plot vs. linear
% figure(i);
% subplot(1,2,1);
% plot(logx, logy);
% hold on;
% plot(logx, linear, 'r');
% 
% % Plot residual
% subplot(1,2,2);
% plot(logx, residual, 'r');