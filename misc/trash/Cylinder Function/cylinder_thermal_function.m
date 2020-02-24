% Returns non-dimensional temperature value of the solution of the heat
% diffusion equation forced by a delta distribution (in 3-space and time),
% subject to the boundary condition of zero temperature at a cylindrical
% surface of radius b (at r = b). The result is computed according to a
% double sum of eigenfunctions. Bessel J zeros are first computed. No
% speed-optimization is done.
%
% Input
%     r: radial coordinate
%     th: polar angle, radians
%     z: elevation
%     t: time (relative to coordinate system)
%     r_0: radial coordinate of source (where the Dirac delta is)
%     th_0: polar angle of source, radians
%     z_0: elevation of source
%     t_0: ignition time
%     b: radius of cylinder defined by problem
% Output
%     F: value of (non-dimensional) temperature

function F = cylinder_thermal_function(r, th, z, t, r_0, th_0, z_0, t_0, b)

% % Test variables
% r = 0.0;
% th = 0;
% z =  0;
% t = 1;
% r_0 = 0.5;
% th_0 = 0;
% z_0 = 0;
% t_0 = 0;
% b = 1;

% Reduced variables
t_r = t - t_0;
th_r = th - th_0;
z_r = z - z_0;

% Heaviside condition
if t <= 0
    F = 0;
    return
end

% Maximum summation index
m_max = 8;
n_max = 8;
% Besseljzero search step
dt = 1;

% Compute Bessel J zeros (alpha)
alpha_matrix = zeros(m_max+1,n_max);
for i = 1:m_max+1
    for j = 1:n_max
        % Manual timestep zeros generator
        if j == 1
            t = dt;
        else
            t = alpha_matrix(i,j-1) + dt;
        end
        % While same sign, keep going
        while (besselj(i-1,t)) * besselj(i-1,t+dt) > 0
            t = t + dt;
        end
        % Use bisection-ready range to solve for zeros
        range = [t, t+dt];
        alpha_matrix(i,j) = fzero(@(x) besselj(i-1,x), range);
    end
end

% Bessel J matrix: alpha_matrix(nu+1,k)
% Omega factor computation
F = @(m,n) besselj(m,alpha_matrix(m+1, n)*r_0/b) *...
    besselj(m,alpha_matrix(m+1, n)*r/b) / ...
    (besselj(m+1,alpha_matrix(m+1, n)))^2 * ...
    exp(-alpha_matrix(m+1, n)^2*(t_r)) * ...
    cos(m*th_r);
sum = 0;
for n = 1:n_max
    sum = sum + 0.5 * F(0,n);
    for m = 1:m_max
        sum = sum + F(m,n);
    end
end

% Phi factor computation (1D Green's)
sum = sum / sqrt(4*pi*t_r) * exp(-0.25*z_r^2/t_r);

% Constant, and return
F = sum / pi^2 / b^2;
return