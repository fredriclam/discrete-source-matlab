try
close(1);
end
figure(1);
hold ('on');
plot(Tign005beta(1:25,1),Tign005beta(1:25,2),'ro');
axis([0, 14, 0, 0.4]);

plot(Tign010beta(1:25,1),Tign010beta(1:25,2),'mv');

plot(Tign020beta(1:25,1),Tign020beta(1:25,2),'bs');

xlabel 't';
ylabel 'W';

plot([0,15],[1/3,1/3],'k-');
labels = {'T_{ign} = 0.05', 'T_{ign} = 0.10', 'T_{ign} = 0.20'};
legend(labels);
set(gca,'XMinorTick','on','YMinorTick','on');
box on;
% plot(TIGN040200x200(:,1),TIGN040200x200(:,2),'bs');