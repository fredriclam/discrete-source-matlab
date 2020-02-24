% Returns derivative of general Green's function dG. Accepts vector y
function dG = generalGreenDerivative(tauc,x,y,t)
r2 = meshgrid(x,y).^2+meshgrid(y,x)'.^2;
t = meshgrid(t,y);
% Encounter with dirac
if t == tauc
    error('Singular value @ generalGreenDerivative');
end
% First term
if t > tauc
    firstTerm = -exp(-r2./(4*(t-tauc))) ./ (t-tauc);
else
    firstTerm = 0;
end
% dG with dirac discarded
dG = 1./(4*pi*tauc) .* ...
    (firstTerm + exp(-r2./(4*t))./t);
% Green tauc derivative
% G = @(x,y,dt) ((meshgrid(x,y).^2+meshgrid(y,x)'.^2) - ...
%     4*(meshgrid(dt,y)))./(16*pi*meshgrid(dt,y).^3) .* ...
%     exp(-(meshgrid(x,y).^2+meshgrid(y,x)'.^2)./(4.*(meshgrid(dt,y))));