figure(26); 
% tauc vs. "stochastic scale" (N.B. large tau_c sees length ~ sqrt(\tau_c))
plot([datCyl(1:end-1).tau_c], 1./[datCyl(1:end-1).characteristic_scale], '.');

figure(27);
plot([datSlab.tau_c], 1./[datSlab.characteristic_scale], '.');

%% Relative

% Sigma is such that fit is f(x) = 0.5 (1 + erf((x-c)/sigma))
figure(28);
plot([datCyl(1:end-1).tau_c], 1./[datCyl(1:end-1).characteristic_scale]...
    ./ [datCyl(1:end-1).critical_dimension], '.');
x_str = '$\tau_\mathrm{c}$';
y_str = '$\sigma/d_{50}$';

figure(29);
plot([datSlab.tau_c], 1./[datSlab.characteristic_scale]...
    ./ [datSlab.critical_dimension], '.');

% Let's look at various TIGN