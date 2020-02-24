% Plot influence of periodic boundary condition:
% Plot 777: (blue) periodic; (red) free-space
% Plot 778: Blue divided by red

% Numerical Parameters
N = 100;
resolution_y = 5000;
% Problem Parameters
L = 100;
t = 1;

% Allocate and define
y_vector = linspace(-L/2,L/2,resolution_y);

term = @(y,y_0,t,k)...
    cos(2*pi*k/L.*(y-y_0)).*...
    exp(-4*pi^2*k^2/L^2.*t);

theta_1 = @(u,u_0,t)...
    1./sqrt(4*pi.*t).*exp(-(u-u_0).^2./4./t);

partial_sum = 0;
for i = 1:N
    partial_sum = partial_sum + term(y_vector,0,t,i);
end
% Periodic width-factor
S = (1+2*partial_sum)/L;
% Free-space width-factor
Th = theta_1(y_vector,0,t);
% S factor divided by theta (free-space width-factor)
F = S ./ Th;

figure(777);
plot(y_vector, S);
adjplot('\ity','\itQ')
hold on
plot(y_vector, Th, ':r');
figure(778);
plot(y_vector, F);