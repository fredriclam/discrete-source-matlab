% Attempt to obtain analytic information about the continuum solution to
% reaction-diffusion equation for a slab.
% Approach: draw a moving control volume that extends from x = -Inf to the
% front at x = 0 (assumed planar), and then write the solution to the heat
% equation due to a traveling boxcar function H(x-ut) - H(x-u(t+1)) via
% convolution with the Green's function. Integrating this expression over
% the control volume gives the total amount of energy inside the control
% volume. Taking d/dt gives the rate of energy change within the control
% volume. The order this is done is: convolution in x_0, y_0, followed by
% integration over x, y and then the partial d/dt is taken, and finally
% convolution is completed over tau with t = 0-. Using this in Reynolds
% Transport and allowing the control volume to move at speed u (flame
% speed), we can root-find the correct u that gives net zero energy change
% in the system for a given T_ign, xi.
%
% Limitations: assumed the flame front is flat, so for small slab
% thicknesses, the flame speed and such may not be accurate. However, at
% large slab thicknesses, the flame speed should be correct (which is
% somehow not the case...!)

%% Param
T_ign = 0.;
%% Plot energy balance against flame speed u
xi = 500;
u_vector = linspace(0,4.5,100);
H = nan(size(u_vector)); L = H; S = H; uu = H;
for i = 1:length(u_vector)
    [~, L(i), H(i)] = energyFn(u_vector(i), xi);
    S(i) = u_vector(i)*xi*T_ign;
end
figure(74); clf; plot(u_vector, L+H+S);
% hold on;
% plot(u_vector, L+H);

%% Xi
xi_vector = linspace(1.2, 1000, 100);
u_corr = nan(size(xi_vector));

for j = 1:length(xi_vector)
    u_corr(j) = fzero(@(u) energyFn(u,xi_vector(j)) + ...
        u*xi_vector(j)*T_ign, 2);
end
figure(75); clf; plot(xi_vector, u_corr);