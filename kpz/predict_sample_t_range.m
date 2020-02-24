% Uses empirical sampled data (hand-picked 5, average of last entry) and
% returns an interpolated estimate for the total problem-time of 200-long
% instant-burn source. The plot looks like the reuslts from [TangPRE2011].

function Recommended_t_f = predict_sample_t_range()
% Manual input data for tauc = 0
T_ign_range = [0.025, 0.050, 0.100,...
    0.150, 0.200, 0.225,...
    0.250, 0.275, 0.300,...
    0.350, 0.400];
end_t_range = [11.3, 13.9, 18.7,...
    23.7, 29.5, 32.2,...
    36.6, 40.4, 44.1,...
    55.7, 69.6];
% Compute the average speed (for plotting purposes)
v_range = 200 ./ end_t_range;

% Hand-filled ranges
T_ign_range_fill = 0.025:0.025:0.4;
end_t_range_fill = [11.3, 13.9, 16.3, 18.7,...
    21.2, 23.7, 26.6, 29.5,...
    32.2, 36.6, 40.4, 44.1,...
    49.9, 55.7, 62.6 , 69.6];

% Extending range by extrapolating 50x50 data
T_ign_range_fill = 0.025:0.025:0.5;
end_t_range_fill = [end_t_range_fill, 77, 86.4, 108, 120];

Recommended_t_f = [T_ign_range_fill; 0.9*end_t_range_fill];

% Illustrate t_f vs. T_ign
% plot(T_ign_range_fill, end_t_range_fill);

% % Plotting continuum speed and empirical dots
% % Construct continuum solution
% RES = 100;
% x_vector = linspace(0,1,RES);
% y_vector = x_vector;
% for i = 1:length(x_vector);
%     y_vector(i) = flame_switch_speed(x_vector(i));
% end
% % Generate plot
% semilogy(x_vector,y_vector);
% % Merge empirical plot
% hold on
% semilogy(T_ign_range, v_range);


% Function that returns the continuum flame speed according to the ignition
% temperature model.
function flame_speed = flame_switch_speed(theta_ign)
theta_function = @(x) (1 - exp(-x.^2) ) ./ x.^2;
options = optimoptions('fsolve','Display','none');
flame_speed = fsolve(@(x) theta_function(x) - theta_ign,1,options);