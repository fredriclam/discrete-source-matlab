T_ign = 0.5;
c = 1;
eta = 0.1;
T = @(x) T_ign + c*x.^(1-eta) - x;