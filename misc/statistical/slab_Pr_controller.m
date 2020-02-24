% Expected nearest neighbour contribution main version

% Numerical parameters:
% Integration resolution
theta_ign = 0.05;
tau = 0.0001;

thickness_range = linspace(0.5,3,10);
pr_range = zeros(size(thickness_range));

for i = 1:length(thickness_range)
    thickness = thickness_range(i);
    pr_range(i) = slab_Pr_propagation(tau, theta_ign, thickness);
end
figure;
plot(thickness_range, pr_range)

theta_ign = 0.1;

for i = 1:length(thickness_range)
    thickness = thickness_range(i);
    pr_range(i) = slab_Pr_propagation(tau, theta_ign, thickness);
end
figure;
plot(thickness_range, pr_range)

theta_ign = 0.15;

for i = 1:length(thickness_range)
    thickness = thickness_range(i);
    pr_range(i) = slab_Pr_propagation(tau, theta_ign, thickness);
end
figure;
plot(thickness_range, pr_range)

theta_ign = 0.2;

for i = 1:length(thickness_range)
    thickness = thickness_range(i);
    pr_range(i) = slab_Pr_propagation(tau, theta_ign, thickness);
end
figure;
plot(thickness_range, pr_range)