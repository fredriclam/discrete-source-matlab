close all;

taucRange = logspace(-5,1,50);
speedRange = zeros(size(taucRange));
for i = 1:length(taucRange)
    tauc = taucRange(i);
    speedRange(i) = 1./solvePeriod(tauc, 0);
end
loglog(taucRange,speedRange,'k');
% ylim([1e-1, 1e1])
xlim([1e-4, 1e1])
hold on

% Filling
fillBottomCurve = zeros(size(taucRange))+1e-2;
h = fill([taucRange,fliplr(taucRange)], ...
    [fillBottomCurve, fliplr(speedRange)], [127 127 127]/255);
ylim([1e-2,1e1])

%% Test section
for Q = linspace(0.01,0.99,30)
    for i = 1:length(taucRange)
        tauc = taucRange(i);
        speedRange(i) = 1./solvePeriod(tauc, Q);
    end
    loglog(taucRange,speedRange,'r');
end

%%
for i = 1:length(taucRange)
    tauc = taucRange(i);
    speedRange(i) = 1./solvePeriod(tauc, 0.1);
end
loglog(taucRange,speedRange,'r');

for i = 1:length(taucRange)
    tauc = taucRange(i);
    speedRange(i) = 1./solvePeriod(tauc, 0.75);
end
loglog(taucRange,speedRange,'b');

for i = 1:length(taucRange)
    tauc = taucRange(i);
    speedRange(i) = 1./solvePeriod(tauc, -0.1);
end
loglog(taucRange,speedRange,'r');

for i = 1:length(taucRange)
    tauc = taucRange(i);
    speedRange(i) = 1./solvePeriod(tauc, -0.75);
end
loglog(taucRange,speedRange,'b');

legend({'Metronome-like popping', 'Infamous Grey Zone',...
    'Bounds from pop-pop-wait-wait rhythm', ...
    'Bounds from pop-pop-wait-wait-wait-wait-wait-wait rhythm'});

xlabel ('{\it\tau}_c','FontSize',16);
ylabel ('{\it\eta}','FontSize',16);

% for i = 1:length(taucRange)
%     tauc = taucRange(i);
%     speedRange(i) = 1./solvePeriod(tauc, 0.99);
% end
% loglog(taucRange,speedRange,'y');
% 
% for i = 1:length(taucRange)
%     tauc = taucRange(i);
%     speedRange(i) = 1./solvePeriod(tauc, 0.99);
% end
% loglog(taucRange,speedRange,'y');