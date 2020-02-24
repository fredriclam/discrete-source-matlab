% Checking again to see if the cylindrical Dirichlet BCs can be correctly
% implemented. Method: applying different number of terms directly to the
% problem we want to solve and checking the flame speed (top-down approach)

%% Generate random cloud

cyl_radius = 2.2;%3.5, 3, 2.2;
length_x = cyl_radius*2;
length_y = cyl_radius*2;
length_z = cyl_radius*2*10; % Propagation direction
T_ign = 0.1;%0.3, 0.2, 0.1;
source_count = round(pi/4*length_x*length_y*length_z);

% Particle vectors
r = length_x/2*sqrt(rand(source_count,1));
th = 2*pi*rand(source_count,1);
z = length_z * rand(source_count,1);
t_ign = 9e9+zeros(source_count,1);

Q = sortrows([r, th, z, t_ign], 3);
r = Q(:,1);
th = Q(:,2);
z = Q(:,3);
t_ign(1:round(0.1*length(t_ign))) = 0;
clear Q;
%% Global parameters
dt = 5e-4;
t_max = 2; % 5, 4, 2

% Pack variables
param.dt = dt;
param.source_count = source_count;
param.t_max = t_max;
param.cyl_radius = cyl_radius;
param.T_ign = T_ign;

data.r = r;
data.th = th;
data.z = z;
data.t_ign = t_ign;
%% Isoparametric tests
%% Test
% Parameters
param.M = 4;
param.N = 4;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{1} = topdown_test_run_chunking(param, data);
%% Test
% Parameters
param.M = 8;
param.N = 4;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{2} = topdown_test_run_chunking(param, data);
%% Test
% Parameters
param.M = 12;
param.N = 4;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{3} = topdown_test_run_chunking(param, data);
%% Test
% Parameters
param.M = 16;
param.N = 4;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{4} = topdown_test_run_chunking(param, data);
%% Test
% Parameters
param.M = 16;
param.N = 6;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{5} = topdown_test_run_chunking(param, data);
%% Test
% Parameters
param.M = 30;
param.N = 3;
param.alpha_table = heatResponseCD_construct_alpha(param.M,param.N);
t_ign_data{6} = topdown_test_run_chunking(param, data);

%% Plot ignition
plot(z,t_ign_data{1}, '.k');
xlim([0, ceil(max(z))]);
ylim([0, max([0.1, max(t_ign_data{1}(t_ign_data{1} < 1e8))])]);
xlabel 'z'; ylabel 't_{ign}'
hold on
plot(z,t_ign_data{2}, '+b');
plot(z,t_ign_data{3}, 'or');
plot(z,t_ign_data{4}, 'xg');
plot(z,t_ign_data{5}, '*y');
plot(z,t_ign_data{6}, '^m');
% plot(z,t_ign_data{7}, '^c');
% plot(z,t_ign_data{8}, '*k');
% plot(z,t_ign_data{9}, 'xb');
xlim([0, 40]); ylim([0, 2]); xlabel 'z'; ylabel 't_{ign}'
legend({'4,4','8,4','12,4','16,4','16,6','30,3'})

%% Prop speed analysis
CASES = 6;
speed = zeros(1,CASES);
lower_limits = speed;
upper_limits = speed;
for i = 1:CASES
    t_ign_curr = t_ign_data{i};
    cf{i} = fit(t_ign_curr(t_ign_curr > 0 & t_ign_curr < 1e8), ...
        z(t_ign_curr > 0 & t_ign_curr < 1e8), 'poly1');
    speed(i) = cf{i}.p1;
    ci = confint(cf{i});
    lower_limits(i) = speed(i) - ci(1,1);
    upper_limits(i) = ci(2,1) - speed(i);    
end

plot_x = [4, 8, 12, 16, 16.1, 30];
plot_y = speed;
plot_L = lower_limits;
plot_U = upper_limits;
figure;
errorbar(plot_x, plot_y, plot_L, plot_U);
xlabel 'M'
ylabel 'Prop speed'
%% Notes
% u(j,i) = ICHR_polar(r,r0,diff_t,diff_th,diff_z,cyl_radius,...
%     M,N,ICHR_construct_alpha(M,N));

% % Parameters
% M = 7;
% N = 7;
% alpha_table = ICHR_construct_alpha(M,N);
% t_ign = t_ign_original;
% 
% % Global t
% t = 0;
% ignite_count = 0;
% while t < t_max && ignite_count < source_count;
%     for i = 1:length(t_ign)
%         % Check each unignited for ignition
%         if t_ign(i) >= 1e8
%             T = 0;
%             % Sum contribution from ignited
%             for j = 1:length(t_ign)
%                 if t > t_ign(j)
%                     T = T + ...
%                         ICHR_polar(r(i),r(j),t-t_ign(j),th(i)-th(j), ...
%                         z(i)-z(j),cyl_radius,M,N,alpha_table);
%                 end
%             end
%             
%             if T > T_ign
%                 t_ign(i) = t;
%                 ignite_count = ignite_count + 1;
%             end
%         end
%     end
%     t = t + dt
% end
% t_ign77 = t_ign;