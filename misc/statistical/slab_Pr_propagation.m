% Returns probability
%  Input arguments: you know it

function pr = slab_Pr_propagation(tau, theta_ign, thickness)

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
s_res = 8*10; % Standoff (depth)
t_res = 16*5; % Time (find maximum)
t_min = 0.01;% 0.001
t_max = 3; %1 

% Generate range of standoff distances from edge
s_range = linspace(0, thickness/2, s_res);
% Generate range of time (find the maximum)
t_range = linspace(t_min,t_max,t_res);
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

for j = 1:length(s_range)
    % Get current standoff distance / depth (sigma)
    standoff_sigma = s_range(j);
    % Work for a sample of time ranges
    for i = 1:length(t_range)
        % Get current time
        t = t_range(i);
        % Differential of first moment of psi
        dmu1_psi = @(r,t) pdf_slab(r,thickness,standoff_sigma) .* ...
            K(r,t);
        % Differential of second moment of psi
        dmu2_psi = @(r,t) pdf_slab(r,thickness,standoff_sigma) .* ...
            K(r,t) .^2;
        % Prob prop given theta_ign: 50%: propagation direction
        dprob = @(r) pdf_slab(r,thickness,standoff_sigma);

%         % Numerical integration
%         if j == 1
%             E_range(i) = sum(dmu1_psi(r_range,t))*...
%                 (integral_lim_high-integral_lim_low)/integration_res;
%             variance_range(i) = sum(dmu2_psi(r_range,t))*...
%                 (integral_lim_high-integral_lim_low)/integration_res;
%         end
        
        prob_range(i) = sum(dprob(r_range))*...
            (integral_lim_high-integral_lim_low)/integration_res;
    end
    prob_matrix(j,:) = prob_range;
    
    % Plotting action for first one
%     if j == 1
%         figure(1); clf;
%         plot(t_range, E_range)
%         xlabel 't'
%         ylabel 'E(\theta)'
%         title 'Mean temperature'
% 
%         figure(2); clf;
%         plot(t_range, sqrt(variance_range))
%         xlabel 't'
%         ylabel '\mu_2'
%         title 'Second moment \sqrt{E(\theta^2)}'
%         
%         figure(3); clf;
%         ezplot(@(r) pdf_slab (r,thickness,standoff_sigma), [0,5]);
%         ylabel 'PDF'
% 
%         figure(4); clf;
%         plot(t_range, prob_range)
%         xlabel 't (meaningless)'
%         ylabel 'Pr({\it\theta} > {\it\theta}_{ign})'
%     end
end

% figure(5); clf;
% plot(t_range, prob_matrix)
% xlabel 't (meaningless)'
% ylabel 'Pr({\it\theta} > {\it\theta}_{ign})'

% figure(6); clf;
% plot(s_range, prob_of_sigma)
% xlabel 'sigma'
% ylabel 'Pr'

% Calculate probability of propagation at point as a function of sigma
prob_of_sigma = max(prob_matrix,[],2);
% Average probability over sigma (uniformly distributed)
pr = sum(prob_of_sigma) ./ numel(prob_of_sigma);

