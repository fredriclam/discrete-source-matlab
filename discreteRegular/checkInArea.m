xRadius = 10;
yRadius = 10;

% Define function
fn = @generalGreen;

% Computes sheet contribution s
sKernel = @(tauc,x,dt,ySamples) sum(fn(tauc,x,ySamples,dt));
s = @(tauc,x,dt) sKernel(tauc,x,dt,-yRadius:1:yRadius);
% Compute total S
SKernel = @(tauc, xSamples,dtSamples) sum(s(tauc,xSamples,dtSamples));

% Test parameters for theta_ign = 0.6
dt = 1/1;
tauc = 1e-1;

% Initialize tSample
tSample = (1:1:xRadius)-1;

% Check
S = @(tauc, dt) SKernel(tauc, -1:-1:-xRadius, tSample+dt);
R = fzero(@(dt) S(tauc, dt) - 0.6, 0.1);
%% Test
tRange=linspace(0.01,1,100);
yRange=zeros(size(tRange));
for i = 1:length(tRange)
    yRange(i) = S(tauc,tRange(i));
end
plot(tRange, yRange);
%%
% Computes sheet contribution s
sKernelprime = @(tauc,x,dt,ySamples) sum(generalGreenDerivative(tauc,x,ySamples,dt));
sprime = @(tauc,x,dt) sKernelprime(tauc,x,dt,-yRadius:1:yRadius);
% Compute total S
SKernelprime = @(tauc, xSamples,dtSamples) sum(sprime(tauc,xSamples,dtSamples));
Sprime = @(tauc, dt) SKernelprime(tauc, -1:-1:-xRadius, dt*tSample);
Sprime(tauc,R)