t_r = 0.00001;
r = 1;
psi3 = @(r,t,t_r) 1./(4.*pi.*r.*t_r) .* ...
    (erfc(r./(2.*sqrt(t))) - ...
    heaviside(t-t_r) .* ...
    erfc(real(r./(2.*sqrt(t-t_r)))));
psi3_0 = @(r,t) 1./(4.*pi.*t).^(3/2) .* ...
    exp(-r.^2./(4*t));
t = linspace(0,5,500);
y0 = psi3_0(r,t);
clf
plot(t,y0,'k-')
hold on

parameters = logspace(-2,2,5);
for i = 1:5
    t_r = parameters(i);
    y = psi3(r,t,t_r);
    plot(t,y,'*','color',get_rainbow_colour(i,5));
end