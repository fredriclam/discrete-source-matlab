function P_avg = scratch_pad15(theta_ign,cyl_radius, table)
tau = 0.0001;
% theta_ign = 0.01;
r_star = r_max_of_theta(tau, theta_ign);
% cyl_radius = .82;
r_res = 50;

chicken_rice = @(sigma, P, cyl_radius) 1 - exp(-1/2 *...
    get_shape_value(cyl_radius-sigma,...
        r_star,cyl_radius,table) *...
    (4/3*pi)* r_star.^3 * P) - P;

sigma_range = linspace(0,cyl_radius,r_res);
P_range = zeros(size(sigma_range));

for i = 1:length(sigma_range)
    sigma = sigma_range(i);
    chicken_curry = @(P) chicken_rice(sigma, P, cyl_radius);
%     x_range = linspace(0,1,100);
%     for j = 1:length(x_range)
%         x = x_range(j);
%         y_range(j) = chicken_curry(x);
%     end
%     plot(x_range, y_range); if i == 1; hold on; end; pause;
    
    % Check derivative near zero:
    dP = 0.001;
    dcurry = chicken_curry(dP) - chicken_curry(0); 
    if dcurry > 0
        P_range(i) = fzero(chicken_curry,[dP,1]);
    else
        P_range(i) = 0;
    end
%     P_range(i) = fzero(chicken_curry,1);
end
% clc;
% disp(P_range);

r_range = cyl_radius - sigma_range;
[r_range_cleaned, P_range_cleaned] = prepareCurveData(r_range, P_range);
dr = cyl_radius/(length(r_range_cleaned)-1);
P_avg = ...
    ...(2 ./ cyl_radius.^2 .* dr .* sum(r_range_cleaned .* P_range_cleaned));
    (2 ./ cyl_radius.^2 .* dr .* sum(r_range_cleaned .* P_range_cleaned)) >= .5;
    ...2 * pi * dr .* sum(r_range_cleaned .* P_range_cleaned) >= 1; % face integral
    ...max(P_range_cleaned);
% disp(2*cyl_radius)