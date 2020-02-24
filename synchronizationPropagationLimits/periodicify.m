% Returns function handle to periodicified function S(tauc, dt)
function S = periodicify(fn, yRadius, xRadius, d1)
% Computes sheet contribution s
sKernel = @(tauc,x,dt,ySamples) sum(fn(tauc,x,ySamples,dt));
s = @(tauc,x,dt) sKernel(tauc,x,dt,-yRadius:1:yRadius);
% Compute total S
SKernel = @(tauc, xSamples,dtSamples) sum(s(tauc,xSamples,dtSamples));

% Metronome
% S = @(tauc, dt) SKernel(tauc, -xRadius:1:-1, dt*(xRadius:-1:1));

% Include periodic disturbance d1 (fraction)
tSample(1:2:xRadius) = (1:2:xRadius) - d1;
tSample(2:2:xRadius) = 2:2:xRadius;
S = @(tauc, dt) SKernel(tauc, -1:-1:-xRadius, dt*tSample);
