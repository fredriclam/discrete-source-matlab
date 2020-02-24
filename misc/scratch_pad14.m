
% WIP Simple integral
% % Get current standoff distance / depth (sigma)
%     standoff_sigma = s_range(j);
%     
%     % Integral 
%     sum(stable_integrand_cyl(r_range,...
%         diameter, ...
%         standoff_sigma, ...
%         1,...
%         table)) .* (integral_lim_high-integral_lim_low)/integration_res;
%     
%     obj_func = @(PR) shooting_integral(PR) - 1;
%     prob_ss = fzero(obj_func, 1);

s = slab_Pr_equilibrium(0.0001,0.05,.95)
c = cyl_Pr_equilibrium(0.0001,0.05,1.95,standard_table)

s = slab_Pr_equilibrium(0.0001,0.1,1.41)
c = cyl_Pr_equilibrium(0.0001,0.1,3.45,standard_table)

s = slab_Pr_equilibrium(0.0001,0.12,3.22)
c = cyl_Pr_equilibrium(0.0001,0.12,7.65,standard_table)