% %% Calculate critical thickness over theta_ign range
% theta_range = linspace(0.01,0.20,20);
% t_crit_range = zeros(size(theta_range));
% for i = 1:length(theta_range)
%     theta = theta_range(i);
%     t_crit_range(i) = fzero(@(thickness)...
%         slab_Pr_equilibrium(0.0001, theta, thickness) - 0.5,1);
% end

%% Build shape function of sphere
s_range = linspace(0,3,20);
a_range = linspace(0,3,20);
shape_matrix = zeros(length(s_range),length(a_range));
rng('shuffle');
for i = 1:length(s_range)
    s = s_range(i);
    for j = 1:length(a_range)
        a = a_range(j);
        shape_matrix(i,j) = monte_carlo_sphere(a,s,1);
    end
end

% Viz
surf(s_range,a_range,shape_matrix)
xlabel 's'
ylabel 'a'