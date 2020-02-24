tauc_range = [0 logspace(-1,1,4)];
t_range = logspace(-3,2,1000);
mu0_range = nan(length(tauc_range), length(t_range));
mu1_range = nan(length(tauc_range), length(t_range));
for i = 1:length(tauc_range)
    tauc = tauc_range(i);
    for j = 1:length(t_range)
        t = t_range(j);
        moments = heatReleaseMoment(tauc,t);
        mu0_range(i,j) = moments(1);
        mu1_range(i,j) = moments(2);
    end
end
subplot(1,2,1);
loglog(t_range,mu1_range);
xlabel 't'
ylabel '\mu_1'
subplot(1,2,2);
plot(t_range,mu0_range);


% Good range
% tauc_range = linspace(0,1.2,6);
% t_range = linspace(0,2,200);
% mu0_range = nan(length(tauc_range), length(t_range));
% mu1_range = nan(length(tauc_range), length(t_range));
% for i = 1:length(tauc_range)
%     tauc = tauc_range(i);
%     for j = 1:length(t_range)
%         t = t_range(j);
%         moments = heatReleaseMoment(tauc,t);
%         mu0_range(i,j) = moments(1);
%         mu1_range(i,j) = moments(2);
%     end
% end
% subplot(1,2,1);
% plot(t_range,mu1_range);
% xlabel 't'
% ylabel '\mu_1'
% subplot(1,2,2);
% plot(t_range,mu0_range);