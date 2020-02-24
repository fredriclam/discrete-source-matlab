% plt = @(u,i,I) plot([u.theta_ign],[u.critical_dimension],...
%     'color', get_rainbow_colour(i,I));
% 
% figure(1); clf;
% plt(Q(1:14),1,16); hold on;
% plt(Q(15:28),4,16);
% plt(Q(29:42),12,16)
% plt(Q(43:56),16,16)
% 
% figure(2); clf;
% plt(Q(57:70),1,16); hold on;
% plt(Q(71:83),4,16); hold on;
% plt(Q(84:96),12,16); hold on;
% plt(Q(97:109),16,16); hold on;

% Select vector
v1 = Q(1:13);
v_cd1 = [v1.critical_dimension];
v2 = Q(15:27);
v_cd2 = [v2.critical_dimension];
v3 = Q(29:41);
v_cd3 = [v3.critical_dimension];
v4 = Q(43:55);
v_cd4 = [v4.critical_dimension];
s1 = Q(57:69);
s_cd1 = [s1.critical_dimension];
s2 = Q(71:83);
s_cd2 = [s2.critical_dimension];
s3 = Q(84:96);
s_cd3 = [s3.critical_dimension];
s4 = Q(97:109);
s_cd4 = [s4.critical_dimension];

theta_ign = [v1.theta_ign];
key = {'0','0.001','0.1','1'};

figure(4)
V = [v_cd1; v_cd2; v_cd3; v_cd4]';
plot(theta_ign, V);
legend(key);
figure(5)
S = [s_cd1; s_cd2; s_cd3; s_cd4]';
plot(theta_ign, S);
legend(key);
figure(6)
plot(theta_ign, V ./ S);
legend(key);

% Check sigmoid plot
% figure(3);
% % hold on;
% for i = 1:length(Q)
% disp(Q)
% Q(i).plot()
% pause
% end