% Returns the flame speed as a function of nondimensional ignition
% temperature according to the continuum ignition temperature model
% (see 1DFlameSwitchTypeModel_XCM.pdf)

function flame_speed = flame_switch_speed(theta_ign, tauc)
if nargin == 1
    flame_speed = flame_switch_speed_XC(theta_ign);
    return
elseif nargin == 2
    theta_function = @(x) (1 - exp(-x.^2*tauc) ) ./ (x.^2*tauc);
    options = optimoptions('fsolve','Display','none');
    flame_speed = fsolve(@(x) theta_function(x) - theta_ign,1,options);
else
    error 'Not enough input arguments.'
end


% old version ~ compatible witth exact_flame_solution
% essential tauc = 1 with the above formulation (normalized)
function flame_speed = flame_switch_speed_XC(theta_ign)
theta_function = @(x) (1 - exp(-x.^2) ) ./ x.^2;
options = optimoptions('fsolve','Display','none');
flame_speed = fsolve(@(x) theta_function(x) - theta_ign,1,options);