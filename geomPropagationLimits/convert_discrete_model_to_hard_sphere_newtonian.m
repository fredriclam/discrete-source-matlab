% Computes the maximum radius at which at some point in time, the
% temperature at that distance results in the temperature theta_ign. This
% is equivalent to the *DIAMETER* of hard spheres in an overlapping scheme
% (3D sphere percolation, or hard sphere model)--since the distance between
% two sources is equal to two hard sphere radii, but one radius of the
% sphere-of-influence.

function [diam_equivalent] = ...
    convert_discrete_model_to_hard_sphere(tauc, theta_ign, nu)

if tauc > 0 && tauc < 1e-2
    warning('Root finder not tuned to value of tauc. May not be correct')
elseif tauc > 0.5 && theta_ign > 0.01
    warning('Root may not exist')
end

% Archival
% r_vector = linspace(0.01, 3, 200);
% T_vector = zeros(size(r_vector));
% t_vector = zeros(size(r_vector));
% for i = 1:length(r_vector)
%     r = r_vector(i);
%     [T_vector(i), t_vector(i)] = max_at_r(tauc, r);
% end
diam_equivalent = zero_bisection(@(r) max_at_r(tauc,r,nu) - theta_ign);

% Bisection search for zero of monotonic function (~ 1/x)
function x = zero_bisection(f)
tol = 1e-9;
% Assume positive here, and start small
a = 1e-3;
% Find negative
b = 2*a;
while f(b) > 0
    a = b;
    b = b * 2;
end
% Bisection search
while b-a > tol
    m = 0.5*(a+b);
    if f(m) > 0
        a = m;
    else
        b = m;
    end
end
x = 0.5*(a+b);
% x = fzero(f, m);



function [G, t_crit] = max_at_r(tauc, r, nu, TOL)
if nargin == 3
    TOL = 1e-9;
elseif nargin ~= 4
    error('Invalid number of input arguments.');
end

if tauc == 0
    if nu == 0
        t_crit = r^2/6;
        G = heatResponse_0(tauc, [r 0 0], [0 0 0], t_crit, 0);
        return
    else
        t_crit = (sqrt(4*nu*r^2 + 9) - 3)/(4*nu);
        G = exp(-nu*t_crit)* ...
            heatResponse_0(tauc, [r 0 0], [0 0 0], t_crit, 0);
        return
    end
end

if heatResponse_1(tauc, [r 0 0], [0 0 0], tauc + TOL, 0) <= 0
    t_crit = tauc;
    G = heatResponse_1(tauc, [r 0 0], [0 0 0], t_crit, 0);
    return
end

% Bisection root search in unknown interval at t > tau_c
tol = 1e-9;
% Assume positive here
a = tauc+1e-7;
% Step for interval search
step = 0.0001;
% Find negative
b = 2*a;
% Find bracketing interval
while exp(-nu*b)*heatResponse_1(tauc, [r 0 0], [0 0 0], b, 0) - ...
        nu*exp(-nu*b)*heatResponse_0(tauc, [r 0 0], [0 0 0], b, 0) > 0
    step = step * 2;
    b = b + step;
end
% Bisection search
while b-a > tol
    m = 0.5*(a+b);
    if exp(-nu*m)*heatResponse_1(tauc, [r 0 0], [0 0 0], m, 0) - ...
        nu*exp(-nu*m)*heatResponse_0(tauc, [r 0 0], [0 0 0], m, 0) > 0
        a = m;
    else
        b = m;
    end
end
t_crit = 0.5*(a+b);

% fzero implementation (does not stay bounded in interval)
% step = 0.0001;
% t_lower = tauc+TOL;
% t_upper = t_lower + step;
% while heatResponse_1(tauc, [r 0 0], [0 0 0], t_upper, 0) > 0
%     step = step * 2;
%     t_upper = t_upper + step;
% end
% t_crit = fzero(@(t) ...
%     heatResponse_1(tauc, [r 0 0], [0 0 0], t, 0), 0.5*(t_lower + t_upper));

G = exp(-nu*t_crit)*heatResponse_0(tauc, [r 0 0], [0 0 0], t_crit, 0);
return