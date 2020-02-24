% Determine sequence of radii at which we can extend the swiss cheese model
% with multiple overlap possibility, and checks the naive probabilities of
% encountering n particles within the radius r_n. Rough estimate. Note here
% that \tau_c = 0, so we have the relation \theta = 3/(2*pi) * exp(-3/2) *
% r^(-1/3), and we use here the assumption each source is ignited at about
% the same time, yielding \theta_ign / n = 3/(2*pi) * exp(-3/2) * r^(-1/3).
% The probability of finding n points in a sphere embedded in a uniformly
% randomly distributed point field follows the Poisson distribution
% (discrete PDF).

theta_ign = 0.005;
lambda = 1;

% Probability sequence in uniform distribution of points
n_sequence = 1:100;
for i = 1:length(n_sequence)
    n = n_sequence(i);
    r_n_sequence(i) = convert_discrete_model_to_hard_sphere( ...
        0, theta_ign ./ n);
    lambda = 4/3*pi*(r_n_sequence(i))^2; % mean of poisson
    prob_sequence(i) = lambda^n * exp(-lambda) / factorial(n);
end

%% Plot
subplot(1,2,1);
plot(n_sequence, r_n_sequence, 'o');
title 'Compounded radius r_n'
yl = ylim; ylim([0, yl(2)]);
subplot(1,2,2);
plot(n_sequence, prob_sequence, '.')
title 'Naive probability of finding n points in sphere of radius r_n'