x = linspace(0,1,100);
c = 0.^2;
P = @(x) 1 + 2*x.*(1 + x.^3 + x.^8 + x.^15);

R = @(x,c) (-1/pi*log(x)).^(3/2).*x.^c.*P(x);
% Q = @(x,c) (-1/pi*log(x)).^(3/2).*x.^c.*(1 + 2*x.*(1 + x.^3 + x.^8));

figure(1);
plot(x, [R(x,1); R(x,2)]);

% figure(2);
% plot(R(x), x);
% xlabel '\theta'
% ylabel '\itu'

% Trash
% E = R(x)-Q(x);
% disp(E(77));