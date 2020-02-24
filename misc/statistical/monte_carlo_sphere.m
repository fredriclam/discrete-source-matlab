% Returns shape function "phi" for sphere-in-cylinder case using MC
% approach.
% argin:
%   a -- Standoff (sphere centre from cylinder axis)
%   s -- Sphere radius
%   c -- Cylinder radius
% Note geometric similarity implies we can scale a, s, c w.r.t c

function shape = monte_carlo_sphere (a,s,c)
NUM = 100000;

% Renormalize w.r.t c:
s = s ./ c;
a = a ./ c;
c = 1;

% s = 2; % Sphere radius
% c = 1; % Cylinder radius
% a = 1; % Standoff

% In-function generation
theta = 2*pi*rand(1,NUM);
phi = acos(1-2*rand(1,NUM));
z = s .* cos(phi);
% x = r .* cos(theta);
y = s .* sin(phi) .* sin(theta);
% z = s .* cos(phi);
% r = s .* sin(phi); % Planar r coord
% % x = r .* cos(theta);
% y = r .* sin(theta);

register = y.^2 + (z+a).^2 < c.^2 ;
shape = sum(register)/NUM;

% % Sampling testing
% % Solid angle test
% disp(sum(phi < acos(1-1/(2*pi)))/NUM);
% disp(1/(4*pi));
% 
% % Cap test
% z_test = 0.5;
% disp(sum(z > z_test)/NUM);
% disp(0.5*(1-z_test));

% Viviani test (not too useful--it's on the cylinder)
% 16* c^(3/2) * sqrt(s-c)