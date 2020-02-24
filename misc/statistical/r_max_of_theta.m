function r_max = r_max_of_theta(tau, theta_ign)

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

% Range of r
r_range = linspace(0.1,1,100);
theta_range = zeros(size(r_range));
for i = 1:length(r_range)
    r = r_range(i);
    theta_range(i) = theta_max(r, K, tau);
end
% plot(r_range, theta_range);

% Find max r such that theta == theta_ign
i = length(r_range);
while theta_range(i) < theta_ign && i >= 1
    i = i - 1;
end

if i == 0
    r_max = 0;
else
    r_max = r_range(i);
end

% Maximum of theta on time at r
function th = theta_max(r, K, tau)

if tau == 0 || tau > 0.001
    error('Not implemented critical point tauc == 0')
end

if tau <= 0.001
    % Implicit function F(t_cp) = 0 for critical point
    t_critical_point = @(r,t,tau) ...
        exp(r.^2./4 .* tau ./ t ./ (t-tau) ) - (t ./ (t - tau)).^(1.5);
    % % Debug
    %  figure(2)
    %  ezplot(@(t)t_critical_point(r,t,tau), [0 2])
    %  hold on
    % Solve for t_cp
    t = fzero(@(t) t_critical_point(r,t,tau), 0.1);
    assert(isreal(t) && t>0);
    % Compute K(t_cp;r)
else
    t_range = linspace(0.01, 1, 1000);
    theta_range = K(r, t_range);
    t = t_range(theta_range == max(theta_range,[],2));
%     plot(t_range, theta_range); hold on;
%     th = 1;
end
th = K(r,t);
return