rng('shuffle');
clear;clc
NUM = 1000000;

s = 2; % Sphere radius
c = 1; % Cylinder radius
a = 1; % Standoff

theta = 2*pi*rand(1,NUM);
phi = acos(1-2*rand(1,NUM));

z = s .* cos(phi);
r = s .* sin(phi); % Planar r coord
% x = r .* cos(theta);
y = r .* sin(theta);

register = y.^2 + (z+a).^2 < c.^2 ;
disp(sum(register)/NUM);

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