% Forward volume of different geometries

% Sphere of influence calculation
K = @(r,t) 1./(4*pi.*t).^(3/2) .* exp(-r.^2./(4*t));
K_max_t = @(r,theta) K(r,r/6) - theta; % t_crit = 1/6

% Calculate a range of influence radii as functions of ignition temperature
theta_range = linspace(0.01,0.1,10);
r_s_range = zeros(size(theta_range));
for i = 1:length(theta_range)
    theta = theta_range(i);
    r_s_range(i) = fzero(@(r) K_max_t(r,theta),1);
end

% Select sphere of influence
r_sphere_influence = r_s_range(3);

% Numerical range for thickness/diameter, forward volume efficiencies
h_range = linspace(0.01,4,40);
bar_vols = zeros(size(h_range));
slab_vols = zeros(size(h_range));
cyl_vols = zeros(size(h_range));

% Run loop
for i = 1:length(h_range)
    h = h_range(i);
    bar_vols(i) = vol_averaged('bar',h,h,r_sphere_influence);
    slab_vols(i) = vol_averaged('slab',h,0,r_sphere_influence);
    cyl_vols(i) = vol_averaged('cyl',h,0,r_sphere_influence);
end

figure(1); clf;
plot(h_range, [bar_vols; slab_vols; cyl_vols]);
legend('bar','slab','cyl')

figure(2); clf;
plot(h_range, slab_vols ./ cyl_vols)

% Invert data series, use linear interpolation
regular_efficiency_vector = linspace(0,0.7,100);
bar_h_vector = interp1(bar_vols, h_range, regular_efficiency_vector);
slab_h_vector = interp1(slab_vols, h_range, regular_efficiency_vector);
cyl_h_vector = interp1(cyl_vols, h_range, regular_efficiency_vector);

figure(3); clf;
plot(regular_efficiency_vector,...
    [bar_h_vector; slab_h_vector; cyl_h_vector]);
legend('bar','slab','cyl')

figure(4); clf;
plot(regular_efficiency_vector,...
    cyl_h_vector ./ slab_h_vector);
legend('bar','slab','cyl')