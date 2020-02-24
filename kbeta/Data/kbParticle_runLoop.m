% 1 to 13 (inclusive): should be 5500 Ta -- trash
% 14 to 33 (inclusive): 5500 to 6500 Ta
% 34 to 53: back to 5500 Ta
% 54 to 73: 6000 Ta
% 74 to 153: detailed 6000 Ta
% 154 to 233: detailed 6500 Ta

concentrationVector = 0.025:0.025:2.00;
speedVector = nan(size(concentrationVector));

for i = 1:length(concentrationVector)
    concentration_g_L = concentrationVector(i);
    speedVector(i) = kbParticle_run(concentration_g_L); 
end

%% Plotting
figure(999);
plot(concentrationVector,speedVector*100,'.')
xlabel 'Concentration [g/L]'
ylabel 'Flame speed [cm/s]'


% Title string
% title('Oxidizer: 0.27 $\mathrm{kg/m}^3$, $r_\mathrm{p,0}=15~\mathrm{\mu m}$, $h_\mathrm{p}=100~\mathrm{W/m}^{2}\mathrm{K}$, $\kappa=80~\mathrm{m/s}$, \texttt{dt} = 2E-3','Interpreter','latex')