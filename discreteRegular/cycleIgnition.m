P = 1;
while P < 100
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

    if yRange(1) < 0.6 && yRange(3) > 0.6
        break
    end
    
    % subplot(1,2,2);
    % tRange=linspace(1,10,10);
    % yRange=zeros(size(tRange));
    % for i = 1:length(tRange)
    %     yRange(i) = S(tauc,tRange(i));
    % end
    % plot(tRange, yRange);

    disp('Section ended')
    P = P + 1;
    drawnow;
end

%% Direct zero
% R = fzero(@(dt) S(tauc, dt) - 0.6, 0.1);
