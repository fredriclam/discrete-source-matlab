% Exact continuum flame solution (Lewis number Le = Inf)
%
% Input
%     pos: position in wave-attached frame (xi)
%     theta_ign: ignition temperature, nondimensional
%     tau_c: discretness parameter, equal to reaction time with unit
%       spacing l = 1 and diffusivity alpha = 1

function output_temp = exact_flame_solution (pos, theta_ign, tau_c)
% Scale position
pos = pos / sqrt(tau_c);
speed = flame_switch_speed(theta_ign);
preheat_temp = @(pos) theta_ign*exp(-speed*pos);
reaction_zone_temp = @(pos) theta_ign + ...
    speed^-2*exp(-speed^2)*(1-exp(-speed*pos)) - pos/speed;
if pos >= 0
    output_temp = preheat_temp(pos);
elseif pos <= -speed % xi^star
    output_temp = 1;
else
    output_temp = reaction_zone_temp(pos);
end