% Contours of equivalent diameter in theta-tau space

%%

tauc_vector = [0, logspace(-2,2,17)];
theta_ign_vector = 0.025:0.025:1;
equivalent_diam = zeros(length(tauc_vector), length(theta_ign_vector));
for i = 1:length(tauc_vector)
    for j = 1:length(theta_ign_vector)
        equivalent_diam(i,j) = ...
            convert_discrete_model_to_hard_sphere(tauc_vector(i), ...
            theta_ign_vector(j));
    end
end

%%
contourf(theta_ign_vector,tauc_vector,equivalent_diam);
set(gca,'YScale','log');
hold on
contour(theta_ign_vector,tauc_vector,equivalent_diam, [1, 1],...
    'LineColor', [255 0 0]/255, ...
    'LineWidth', 1);
xlabel '{\it\theta}_{ign}'
ylabel '{\it\tau}_c'