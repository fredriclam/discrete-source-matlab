function prob_ss = slab_Pr_equilibrium(tau, theta_ign, thickness)

if numel(tau) > 1 || numel(theta_ign) > 1 || numel(thickness) > 1
    error('In slab_Pr_propagation: scalar parameters only')
end

% Numerical parameters
% Integration parameters (over r)
integral_lim_low = 0.00001;
integral_lim_high = r_max_of_theta(tau, theta_ign); %  Calculate.
integral_lim_inf = 10; %(effectively = Inf; above this, expect PDF(r) = 0)
integration_res = 1000; % Integration resolution (5000)

% Resolution parameters
s_res = 8; % Standoff (depth)

% Generate range of standoff distances from edge
s_range = linspace(0, thickness/2, s_res+1);
% s_range(1) = [];
% s_range = thickness/2;

% Generate range of r (over which the PDF is integrated)
r_range = linspace(integral_lim_low,integral_lim_high,integration_res+1);

% Select temperature "kernel"
if tau == 0
    K = @(r,t) 1./(4*pi*t).^(3/2) .* exp(-0.25*r.^2./t);
elseif tau > 0
    K = @(r,t) 1./(4*pi.*r.*tau) .* (...
            erfc(0.5.*r./sqrt(t)) -...
            heaviside(t-tau) .* erfc(abs(0.5*r./sqrt(t-tau)))...
            );
else
    error ('In slab_Pr_propagation.m: Negative tau');
end

sum_prob_ss = 0;
for j = 1:length(s_range)
    % Get current standoff distance / depth (sigma)
    standoff_sigma = s_range(j);        
    
    % Single particle criterion
    prob_ss = sum(stable_integrand(r_range,...
        thickness, ...
        standoff_sigma, ...
        1)) .* (integral_lim_high-integral_lim_low)/integration_res;
    
    % "Steady-state" criterion
%     shooting_integral = @(PR) sum(stable_integrand(r_range,...
%         thickness, ...
%         standoff_sigma, ...
%         PR)) .* (integral_lim_high-integral_lim_low)/integration_res;
%     obj_func = @(PR) shooting_integral(PR) - 1;
%     prob_ss = fzero(obj_func, 1);

    sum_prob_ss = sum_prob_ss + prob_ss;
end
prob_ss = sum_prob_ss/s_res;

% Calculate probability of propagation at point as a function of sigma
% prob_of_sigma = max(prob_matrix,[],2);
% Average probability over sigma (uniformly distributed)
% pr = sum(prob_of_sigma) ./ numel(prob_of_sigma);

