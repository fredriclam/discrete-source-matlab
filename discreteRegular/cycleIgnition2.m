xRadius = 3;
yRadius = 10;

% Define function
fn = @generalGreen;
% Computes sheet contribution s
sKernel = @(tauc,x,dt,ySamples) sum(fn(tauc,x,ySamples,dt));
s = @(tauc,x,dt) sKernel(tauc,x,dt,-yRadius:1:yRadius);
% Compute total S
SKernel = @(tauc, xSamples,dtSamples) sum(s(tauc,xSamples,dtSamples));

% Get "semi-periodic" derivative function
% Computes sheet contribution s
sKernelprime = @(tauc,x,dt,ySamples) sum(generalGreenDerivative(tauc,x,ySamples,dt));
sprime = @(tauc,x,dt) sKernelprime(tauc,x,dt,-yRadius:1:yRadius);
% Compute total S
SKernelprime = @(tauc, xSamples,dtSamples) sum(sprime(tauc,xSamples,dtSamples));

% Test parameters for theta_ign = 0.6
dt = 1/1;
tauc = 1e-1;

% Craft a xSample
% STart index
startIndex = 1;
xSample = -startIndex :-1:-xRadius;

% Craft a tSample
l = length(xSample)-1;
tSample = tril(ones(l,l))*rand(l,1);
tSample = [0; tSample];
% Turn off some more
% tSample(1:6) = 0;
% tSample = zeros(size(tSample));

% Build S function
S = @(tauc, dt) SKernel(tauc, xSample, tSample+dt);
% Sprime = @(tauc, dt) SKernelprime(tauc, xSample, tSample+dt);

%% Test
figure(77);

subplot(1,2,1); hold on;
tRange=linspace(0.01,0.5,15);
yRange=zeros(size(tRange));
for i = 1:length(tRange)
    yRange(i) = S(tauc,tRange(i));
end
plot(tRange, yRange);


subplot(1,2,2);
tRange=linspace(0.5,10,10);
yRange=zeros(size(tRange));
for i = 1:length(tRange)
    yRange(i) = S(tauc,tRange(i));
end
plot(tRange, yRange);

%% Push loop
tSample =[ 0, 0, 0, 0 ];
xSample = -1:-1:-length(tSample);
TIGN = 0.6;
CUTOFF_TIME = 5;
minimumStep = 1e-7;
relaxationConstant = 0.8;
n = 3;
while n < 6;
    % Build S function
    S = @(tauc, dt) SKernel(tauc, xSample, tSample+dt);
    
    % Step for the drop after kick
    step = 1e-2;
    % Step refinement
    while S(tauc,step) > TIGN && step > minimumStep
        step = step * relaxationConstant;
    end
    if step < minimumStep
        error('too small step')
    end
    disp(step);
    tstep = step;
    while S(tauc,tstep) < TIGN && tstep < 5
        tstep = tstep + step;
    end
    
    newdt = fzero(@(dt) S(tauc,dt)-TIGN, [step tstep]);
    % Push new t
    tSample = [ 0, tSample + newdt ];
    xSample = [ xSample, -n-1 ];
    % Increment
    disp(n)
    n = n + 1;
end

