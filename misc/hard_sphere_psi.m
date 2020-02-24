f = @(x,zeta) exp(-zeta*x)+x-1;

zeta_range = linspace(0.8,3,100);
psi_range = zeros(1,30);
for i = 1:length(zeta_range)
    zeta = zeta_range(i);
    psi = fzero(@(x) f(x,zeta), 0.5);
    if isnan(psi)
        psi = fzero(@(x) f(x,zeta), 0.001);
    end
    % Rounding
    if psi < 10*eps
        psi = 0;
    end
    psi_range(i) = psi;
end

plot(zeta_range, psi_range);
xlabel 'Integration parameter \zeta'
ylabel 'Ignited density \psi'




%%
% Mean psi
mu = .8;
t = 2.6;
I = integral(@(z) exp(mu*t*z.^2),0,t/2); %  interesting results!
1 - 2/t * exp(-mu*t^3/4) * I