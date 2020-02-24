true_speed_matrix = zeros(length(density_range), length(xi_range));

% Divide by averaged length
for j = 1:length(xi_range);
    xi = xi_range(j);
    true_speed_matrix(:,j) = (10*xi) ./ speed_matrix(:,j);
end