% Tests the temperature as function of x, t for 2-D box-car convolution

% Temperature of one source
tauc = 10;
y = 0;

xRange = linspace(0,20,50);
tRange = linspace(0.0001,40,50);
Z = zeros(length(xRange),length(tRange));

for i = 1:length(tRange)
    t = tRange(i);
    Z(:,i) = generalGreen(tauc,xRange,y,t);
end

%%
% Surf
figure(1);
surf(tRange,xRange,Z);
xlabel t; ylabel x;

% Held plot
figure(2); clf;
plot(xRange, tRange(1));
hold on
plot(xRange, Z(:,floor(0.2*length(tRange))));
plot(xRange, Z(:,floor(0.4*length(tRange))));
plot(xRange, Z(:,floor(0.6*length(tRange))));
plot(xRange, Z(:,floor(0.8*length(tRange))));
plot(xRange, Z(:,floor(length(tRange))));