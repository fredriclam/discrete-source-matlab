% Runs while checking % contribution to ignition with information on
% the contributors' distance from the ignited source.

%% Generate random cloud

NUM_RUNS = 10; % 80 (0.01), 30 (0.1)

cyl_radius = 2.4; % 1.4 (0.1, 0.01)
length_x = cyl_radius*2;
length_y = cyl_radius*2;
length_z = cyl_radius*2*10; % Propagation direction
T_ign = 0.2; %
source_count = round(pi/4*length_x*length_y*length_z);

for i = 1:NUM_RUNS
    % Particle vectors
    r = length_x/2*sqrt(rand(source_count,1));
    th = 2*pi*rand(source_count,1);
    z = length_z * rand(source_count,1);
    % Convert to Cartesian
    x = r .* cos(th);
    y = r .* sin(th);
    % Ignition time
    t_ign = 9e9+zeros(source_count,1);

    % Sort by propagation direction coordinate
    Q = sortrows([x, y, z, t_ign], 3);
    x = Q(:,1);
    y = Q(:,2);
    z = Q(:,3);
    % Ignite all in first 10% of z-length
    t_ign(1:round(0.1*length(t_ign))) = 0;
    % Clear temp variable
    clear Q;

    %% Global parameters
    dt = 2e-4;
    t_max = 4.8; %1.2 (0.01), 2.4 (0.1)

    % Pack variables
    param.dt = dt;
    param.source_count = source_count;
    param.t_max = t_max;
    param.cyl_radius = cyl_radius;
    param.T_ign = T_ign;
    param.tauc = 0;

    data{i}.x = x;
    data{i}.y = y;
    data{i}.z = z;
    data{i}.t_ign = t_ign;
end
%% Isoparametric tests
%% Test
% Parameters
tic
for i = 1:NUM_RUNS
    [soln{i}, distances{i}, contributions{i}] = scalingRun(param, data{i});
end
toc

%% Binning
NUM_NEIGHBOURS = 10;
NUM_SAMPLES = 2; % All

unbinned = 0;
for n = 1:NUM_NEIGHBOURS
    for k = 1:NUM_SAMPLES
        % nth-nearest neighbour
        x = distances{k}(n).array;
        y = contributions{k}(n).array;
        
        bin_maxima = 0.1:0.1:1.5;
        bin_count{k,n} = zeros(length(bin_maxima),1);
        bin_value{k,n} = zeros(length(bin_maxima),1);
        
        for i = 1:length(x)
            j = 1;
            while j <= length(bin_maxima) && x(i) >= bin_maxima(j)
                j = j + 1;
            end
            % Flag if not binnable (exceeds range)
            if j > length(bin_maxima)
                unbinned = unbinned + 1;
            else
                % Bin
                bin_count{k,n}(j) = bin_count{k,n}(j) + 1;
                bin_value{k,n}(j) = bin_value{k,n}(j) + y(i);
            end
        end
        
        % Average
        bin_average{k,n} = bin_value{k,n} ./ bin_count{k,n};
    end
end

%% Ensemble-averaging
bin_total_value = zeros(size(bin_value{1},1),NUM_NEIGHBOURS);
bin_total_count = zeros(size(bin_count{1},1),NUM_NEIGHBOURS);
for n = 1:NUM_NEIGHBOURS
    for k = 1:NUM_SAMPLES
        bin_total_value(:,n) = bin_total_value(:,n) + bin_value{k,n};
        bin_total_count(:,n) = bin_total_count(:,n) + bin_count{k,n};
    end
end
bin_grand_average = bin_total_value ./ bin_total_count;

%% Plot bin
bar(bin_maxima-0.1, bin_grand_average, 'stacked');
xlim([0, max(bin_maxima)])
xlabel 'Source-source distance'
ylabel 'Average contribution proportion'
title (['Average contribution proportion at ignition of nearest' ...
        'neighbour at' 'T_{ign} = 0.01'])

%% Plot ignition
% plot(z,t_ign_data{1}, '.k');
% xlim([0, ceil(max(z))]);
% ylim([0, max([0.1, max(t_ign_data{1}(t_ign_data{1} < 1e8))])]);
% xlabel 'z'; ylabel 't_{ign}'
% hold on
% plot(z,t_ign_data{2}, '+b');
% plot(z,t_ign_data{3}, 'or');
% plot(z,t_ign_data{4}, 'xg');
% % plot(z,t_ign_data{5}, '*y');
% % plot(z,t_ign_data{6}, '^m');
% % plot(z,t_ign_data{7}, '^c');
% % plot(z,t_ign_data{8}, '*k');
% % plot(z,t_ign_data{9}, 'xb');
% xlim([0, 40]); ylim([0, 2]); xlabel 'z'; ylabel 't_{ign}'
% legend({'4,4','8,4','12,4','16,4'})

%% Prop speed analysis
% CASES = 4;
% speed = zeros(1,CASES);
% lower_limits = speed;
% upper_limits = speed;
% for i = 1:CASES
%     t_ign_curr = t_ign_data{i};
%     cf{i} = fit(t_ign_curr(t_ign_curr > 0 & t_ign_curr < 1e8), ...
%         z(t_ign_curr > 0 & t_ign_curr < 1e8), 'poly1');
%     speed(i) = cf{i}.p1;
%     ci = confint(cf{i});
%     lower_limits(i) = speed(i) - ci(1,1);
%     upper_limits(i) = ci(2,1) - speed(i);    
% end
% 
% plot_x = [4, 8, 12, 16];
% plot_y = speed;
% plot_L = lower_limits;
% plot_U = upper_limits;
% figure;
% errorbar(plot_x, plot_y, plot_L, plot_U);
% xlabel 'M'
% ylabel 'Prop speed'



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