
L = 1;
N = L^3;
R = 00.5;
n_c = N * (2*R)^3 / L^3;

phi_c = 0.289573;
% Critical volume of sphere (N/L^3 == 1)
eta_c = -log(1 - phi_c);
% efficiency * volume == eta_c
ignition_radius = 1.5;
volume = 4*pi/3*ignition_radius^3;
critical_efficiency = eta_c / volume;