function P_avg = scratch_pad16(theta_ign,thickness)

tau = 0.0001;
% theta_ign = 0.05;
r_star = r_max_of_theta(tau, theta_ign);
% thickness = 1;
z_res = 10;

beef_rice = @(sigma, P, thickness) 1 - exp(-1/2 *...
    get_shape_value_slab(sigma,...
        r_star,thickness) *...
    (4/3*pi)* r_star.^3 * P) - P;

sigma_range = linspace(0,thickness,z_res);
P_range = zeros(size(sigma_range));

for i = 1:length(sigma_range)
    sigma = sigma_range(i);
    beef_curry = @(P) beef_rice(sigma, P, thickness);
    
    x_range = linspace(0,1,100);
    for j = 1:length(x_range)
        x = x_range(j);
        y_range(j) = beef_curry(x);
    end
%     plot(x_range, y_range); if i == 1; hold on; end; pause;
    
    % Check derivative near zero:
    dP = 0.001;
    dcurry = beef_curry(dP) - beef_curry(0); 
    if dcurry > 0
        P_range(i) = fzero(beef_curry,[dP,1]);
    else
        P_range(i) = 0;
    end    
    
%     P_range(i) = fzero(beef_curry,.8);
end
% clc; disp(P_range)

z_range = thickness/2 - sigma_range;
[z_range_cleaned, P_range_cleaned] = prepareCurveData(z_range, P_range);
P_avg = ...(sum(P_range_cleaned)/length(P_range_cleaned));
    max(P_range_cleaned) > 1e-10;