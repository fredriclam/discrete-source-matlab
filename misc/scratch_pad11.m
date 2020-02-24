% Wave analysis of temperature contribution in 3D tau > 0
% (tau < 1)

% F is incorrect
F = @(r,tau) 1./(4*pi.*r.*tau) .*erfc(0.5.*r./tau);

join_point = @(r,tau) 1./(4*pi.*r.*tau) .* erfc(0.5*r./tau);
psi = @(r,t,tau) 1./(4*pi.*r.*tau) .* (...
    erfc(0.5.*r./sqrt(t)) -...
    heaviside(t-tau) .* erfc(0.5*r./sqrt(t-tau))...
);


r_vector = linspace(0.1, 1.5, 100);

figure(1); clf;
y0 = zeros(size(r_vector));
zi0 = zeros(size(y0)); % Debug output: 1 if max @ nat_zero
tau = 0.0001;
for i = 1:length(r_vector)
    r = r_vector(i);
    % Find zero
    zero = fzero(@(t) real(rota(r,t,tau)), 1);
    
    nat_zero = psi(r,zero,tau);
    crossover = join_point(r,tau);
    
    if nat_zero >= crossover
        zi0(i) = 1;
        y0(i) = nat_zero;
    else
        zi0(i) = 0;
        y0(i) = crossover;
    end
end

y1 = zeros(size(r_vector));
zi = zeros(size(y1)); % Debug output: 1 if max @ nat_zero
tau = 0.001;
for i = 1:length(r_vector)
    r = r_vector(i);
    % Find zero
    zero = fzero(@(t) real(rota(r,t,tau)), 1);
    
    nat_zero = psi(r,zero,tau);
    crossover = join_point(r,tau);
    
    if nat_zero >= crossover
        zi(i) = 1;
        y1(i) = nat_zero;
    else
        zi(i) = 0;
        y1(i) = crossover;
    end
end

y2 = zeros(size(r_vector));
zi2 = zeros(size(y2)); % Debug output: 1 if max @ nat_zero
tau = 0.01;
for i = 1:length(r_vector)
    r = r_vector(i);
    % Find zero
    zero = fzero(@(t) real(rota(r,t,tau)), 1);
    
    nat_zero = psi(r,zero,tau);
    crossover = join_point(r,tau);
    
    if nat_zero >= crossover
        zi2(i) = 1;
        y2(i) = nat_zero;
    else
        zi2(i) = 0;
        y2(i) = crossover;
    end
end

y3 = zeros(size(r_vector));
zi3 = zeros(size(y2)); % Debug output: 1 if max @ nat_zero
tau = 0.1;
for i = 1:length(r_vector)
    r = r_vector(i);
    % Find zero
    zero = fzero(@(t) real(rota(r,t,tau)), 1.5);
    
    nat_zero = psi(r,zero,tau);
    crossover = join_point(r,tau);
    
    if nat_zero >= crossover
        zi3(i) = 1;
        y3(i) = nat_zero;
    else
        zi3(i) = 0;
        y3(i) = crossover;
    end
end

plot(r_vector, [y0; y1; y2; y3])

legend({'0.0001', '0.001', '0.01', '0.1'})

title 'Temperature contribution at end of heat-release period'
xlabel 'r'
ylabel '\psi'

rota = @(r,t,tau) exp(r.^2./4 .* tau ./ t ./ (t-tau) ) - (t ./ (t - tau)).^(1.5);
fsolve(@(t) rota(r,t,tau), 1)