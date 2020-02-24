% Isothermal cylinder heat release function
%  -r: target coordinate r
%  -r0: source coordinate r0
%  -diff_t: t-t0
%  -diff_th: theta-theta0
%  -diff_z: z-z0
%  -b: cylinder radius
%  -M: max summation index m
%  -N: max summation index n
%  -alpha: besselj roots table (generated by ICHR_construct_alpha)
%  return: heat release value

function value = ICHR_polar(r, r0, diff_t, diff_th, diff_z, b, M, N, alpha)

% Return value from subfunctions
persistent coeff;
coeff = 1/pi/sqrt(pi)/b^2;
value = coeff ...
    / sqrt(diff_t) ...
    * exp(-diff_z.^2/4./diff_t) ...
    * ICHR_omega(r, r0, diff_t, diff_th, b, M, N, alpha);