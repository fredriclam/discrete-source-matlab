littleSSum = 50;
bigSSum = 50;
% Computes G at vector valued x, y, dt (x, dt same size)
% G = @(x,y,dt) 1./(4*pi*(meshgrid(dt,y))).*exp(-(meshgrid(x,y).^2+meshgrid(y,x)'.^2)./(4.*(meshgrid(dt,y))));
% dG
G = @(x,y,dt) ((meshgrid(x,y).^2+meshgrid(y,x)'.^2) - ...
    4*(meshgrid(dt,y)))./(16*pi*meshgrid(dt,y).^3) .* ...
    exp(-(meshgrid(x,y).^2+meshgrid(y,x)'.^2)./(4.*(meshgrid(dt,y))));

% Computes sheet contribution s
sKernel = @(x,dt,ySamples) sum(G(x,ySamples,dt));
s = @(x,dt) sKernel(x,dt,-littleSSum:1:littleSSum);

% Compute total S
SKernel = @(xSamples,dtSamples) sum(s(xSamples,dtSamples));
S = @(dt) SKernel(-bigSSum:1:-1, dt*(bigSSum:-1:1));

% Compute F
F = @(dt, T0) S(dt) - T0;

% Q: What dt give zeros of F (parametrized by T0)?

% Test
figure(701);
tTest = linspace(0.1, 50, 1000);
fTest = zeros(size(tTest));
for i = 1:length(fTest)
    currentdt = tTest(i);
    fTest(i) = S(currentdt);
end

% A: Green's function summed total as function of time interval between
% ignitions, i.e, inverse of flame speed

subplot(1,2,1);
plot(tTest, fTest);
xlabel 't'
ylabel 'S (\theta_{ign})'

subplot(1,2,2);
plot(1./tTest, fTest);
xlabel 'fspeed'
ylabel 'S (\theta_{ign})'

% figure(702);