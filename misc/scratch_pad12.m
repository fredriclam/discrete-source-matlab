% Expected nearest neighbour contribution
% Important! Copy

clc;

% Numerical parameters:
% Integration resolution
k = 5000;
theta_ign = 0.1;
tau = .001;
thickness = 1.2;
standoff_sigma = thickness/2;
% Effective r = Inf
integral_lim_low = 0.00001;
integral_lim_high = 25;
% Range
t_range = linspace(0.001,1,100);
E_range = zeros(size(t_range));
variance_range = zeros(size(t_range));
prob_range = zeros(size(t_range));

% for i = 1:length(t_range)
%     t = t_range(i);
%     % Expected nearest neighbour contribution function
%     PDF = @(r) 4*pi*r.^2 .* exp(-4/3*pi.*r.^3);
% 
%     % Kernel (tau = 0)
% %     K = @(r,t) 1./(4*pi*t).^(3/2) .* exp(-0.25*r.^2./t);
%     % Kernel (tau != 0)
%     K = @(r,t) 1./(4*pi.*r.*tau) .* (...
%     erfc(0.5.*r./sqrt(t)) -...
%     heaviside(t-tau) .* erfc(abs(0.5*r./sqrt(t-tau)))...
%     );
%     
%     % Shape phi function (slab)
%     shape_phi = @(r, s) heaviside(s-r) .* 1 + ...
%         heaviside(r-s) .* heaviside((thickness-s)-r) .* (1 - 0.5*(1-s./r)) + ...
%         heaviside(r-(thickness-s)) .* 0.5 .* (thickness./r);
%     
%     % Calculate first moment of psi
%     dmu1_psi = @(r,t) PDF(r) .* K(r,t) .* shape_phi(r,standoff_sigma);
%     % Calculate second moment of psi
%     dmu2_psi = @(r,t) PDF(r) .* K(r,t) .^2 .* shape_phi(r,standoff_sigma);
%     % Prob prop given theta_ign: 50% due to directionality
%     dprob = @(r,t,theta) 0.5 * PDF(r) .* ...
%         heaviside(K(r,t)-theta_ign) .* ...
%         shape_phi(r,standoff_sigma);
%     
%     r_range = linspace(integral_lim_low,integral_lim_high,k+1);
%     % Numerical integration
%     E_range(i) = sum(dmu1_psi(r_range,t))*...
%         (integral_lim_high-integral_lim_low)/k;
%     variance_range(i) = sum(dmu2_psi(r_range,t))*...
%         (integral_lim_high-integral_lim_low)/k;
%     prob_range(i) = sum(dprob(r_range,t, theta_ign))*...
%         (integral_lim_high-integral_lim_low)/k;
% end
% 
% figure(1); clf;
% plot(t_range, E_range)
% xlabel 't'
% ylabel 'E(\theta)'
% title 'Mean temperature'
% 
% figure(2); clf;
% ezplot(PDF, [0,5]);
% ylabel 'PDF'
% 
% figure(3); clf;
% ezplot(@(r) shape_phi(r,thickness/2), [0,5])
% ylabel 'Shape factor A/A_0'
% 
% figure(4); clf;
% plot(t_range, sqrt(variance_range))
% xlabel 't'
% ylabel '\mu_2'
% title 'Second moment \sqrt{E(\theta^2)}'
% 
% figure(5); clf;
% plot(t_range, prob_range)
% xlabel 't (meaningless)'
% ylabel 'Pr({\it\theta} > {\it\theta}_{ign})'

%%%%%%%%%%
%
%
% Next up: integrate probability of dot being at r
s_range = linspace(0, thickness/2, 20);
for j = 1:length(s_range)
    standoff_sigma = s_range(j);
    for i = 1:length(t_range)
        t = t_range(i);
        
        
%         % Shape phi function (slab)
%         shape_phi = @(r, s) heaviside(s-r) .* 1 + ...
%             heaviside(r-s) .* heaviside((thickness-s)-r) .* (1 - 0.5*(1-s./r)) + ...
%             heaviside(r-(thickness-s)) .* 0.5 .* (thickness./r);
%         % Expected nearest neighbour contribution function
%         PDF = @(r,s) *...
%             0.5*0.5 * shape_phi(r,s) * 4*pi*r.^2 .*...
%             exp(-4/3*pi.*r.^3 * 0.5 * shape_phi(r,s));
        
        % Kernel (tau == 0)
        % K = @(r,t) 1./(4*pi*t).^(3/2) .* exp(-0.25*r.^2./t);
        % Kernel (tau ~= 0)
        K = @(r,t) 1./(4*pi.*r.*tau) .* (...
            erfc(0.5.*r./sqrt(t)) -...
            heaviside(t-tau) .* erfc(abs(0.5*r./sqrt(t-tau)))...
            );
        
        % Differential of first moment of psi
        dmu1_psi = @(r,t) pdf_slab(r,thickness,standoff_sigma) .* ...
            K(r,t);
        % Differential of second moment of psi
        dmu2_psi = @(r,t) pdf_slab(r,thickness,standoff_sigma) .* ...
            K(r,t) .^2;
        % Prob prop given theta_ign: 50%: propagation direction
        dprob = @(r,t,theta) pdf_slab(r,thickness,standoff_sigma) .* ...
            heaviside(K(r,t)-theta_ign);

        r_range = linspace(integral_lim_low,integral_lim_high,k+1);
        % Numerical integration
        if j == 1
            E_range(i) = sum(dmu1_psi(r_range,t))*...
                (integral_lim_high-integral_lim_low)/k;
            variance_range(i) = sum(dmu2_psi(r_range,t))*...
                (integral_lim_high-integral_lim_low)/k;
        end
        prob_range(i) = sum(dprob(r_range,t, theta_ign))*...
            (integral_lim_high-integral_lim_low)/k;
    end
    prob_matrix(j,:) = prob_range;
    
    % Plotting action for first one
    if j == 1
        figure(1); clf;
        plot(t_range, E_range)
        xlabel 't'
        ylabel 'E(\theta)'
        title 'Mean temperature'

        figure(2); clf;
        plot(t_range, sqrt(variance_range))
        xlabel 't'
        ylabel '\mu_2'
        title 'Second moment \sqrt{E(\theta^2)}'
        
        figure(3); clf;
        ezplot(@(r) pdf_slab (r,thickness,standoff_sigma), [0,5]);
        ylabel 'PDF'

        figure(4); clf;
        plot(t_range, prob_range)
        xlabel 't (meaningless)'
        ylabel 'Pr({\it\theta} > {\it\theta}_{ign})'
    end
end

figure(5); clf;
plot(t_range, prob_matrix)
xlabel 't (meaningless)'
ylabel 'Pr({\it\theta} > {\it\theta}_{ign})'

prob_of_sigma = max(prob_matrix,[],2);

figure(6); clf;
plot(s_range, prob_of_sigma)
xlabel 'sigma'
ylabel 'Pr'

average_prob = sum(prob_of_sigma) ./ numel(prob_of_sigma);

disp (average_prob);