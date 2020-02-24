% Impromptu script to extract (only) scaling data from data structs
% generated from PROP*.dat data files. Maybe something reusable here.

clampData = Q;
cylData = clampData(1:32);
slabData = clampData(33:64);

for i = length(clampData)
    obj = clampData(i);
end

% Sort data
[~,index] = sortrows([cylData.tau_c].'); cylData = cylData(index);
[~,index] = sortrows([cylData.theta_ign].'); cylData = cylData(index);
[~,index] = sortrows([slabData.tau_c].'); slabData = slabData(index);
[~,index] = sortrows([slabData.theta_ign].'); slabData = slabData(index);

% Expand data
for i = 1:length(cylData)
    cylData(i).ci_lower = cylData(i).ci(1);
    cylData(i).ci_upper = cylData(i).ci(2);
end
for i = 1:length(slabData)
    slabData(i).ci_lower = slabData(i).ci(1);
    slabData(i).ci_upper = slabData(i).ci(2);
end

% % Plot data
% theta_ign = dataset(1);
% range = 1:8;
% errorbar([dataset(range).tau_c], [dataset(range).critical_dimension], ...
%     [dataset(range).critical_dimension]-[dataset(range).ci_lower], ...
%     [dataset(range).ci_upper]-[dataset(range).critical_dimension]); hold on;
% 
% theta_ign = dataset(9);
% range = 9:16;
% errorbar([dataset(range).tau_c], [dataset(range).critical_dimension], ...
%     [dataset(range).critical_dimension]-[dataset(range).ci_lower], ...
%     [dataset(range).ci_upper]-[dataset(range).critical_dimension]);
% 
% theta_ign = dataset(17);
% range = 17:24;
% errorbar([dataset(range).tau_c], [dataset(range).critical_dimension], ...
%     [dataset(range).critical_dimension]-[dataset(range).ci_lower], ...
%     [dataset(range).ci_upper]-[dataset(range).critical_dimension]);
% 
% theta_ign = dataset(25);
% range = 25:32;
% errorbar([dataset(range).tau_c], [dataset(range).critical_dimension], ...
%     [dataset(range).critical_dimension]-[dataset(range).ci_lower], ...
%     [dataset(range).ci_upper]-[dataset(range).critical_dimension]);

%%
% Assume isoparametric data
% clf;
theta_ign = cylData(1).theta_ign;
scaling = [cylData.critical_dimension] ./ [slabData.critical_dimension];
cylinderDimension = [cylData.critical_dimension];
slabDimension = [slabData.critical_dimension];
computeCiLower = @(V, range) [V(range).critical_dimension] - [V(range).ci_lower];
computeCiHigher = @(V, range) [V(range).ci_upper] - [V(range).critical_dimension];
tau_c = [cylData.tau_c];
% range = 1:7;
% range = 9:15;
% range = 17:22;
range = 25:30;

% subplot(1,3,1);
figure(1);
errorbar(tau_c(range), cylinderDimension(range), ...
    computeCiLower(cylData, range), computeCiHigher(cylData,range)); hold on;
% subplot(1,3,2);
figure(2);
errorbar(tau_c(range), slabDimension(range), ...
    computeCiLower(slabData, range), computeCiHigher(slabData,range)); hold on;
% subplot(1,3,3);
figure(3);
plot(tau_c(range), scaling(range)); hold on;

% legend({'{\it\theta}_{ign} = 0.05', '{\it\theta}_{ign} = 0.1', '{\it\theta}_{ign} = 0.2', '{\it\theta}_{ign} = 0.3'})