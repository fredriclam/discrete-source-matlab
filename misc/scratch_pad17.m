function [ratio, C, S] = scratch_pad17(theta_ign,table)
resolution = 100;
cyl_range = linspace(0.45,8,resolution);
cyl_radii = zeros(size(cyl_range)); % Actually a probability ****
slab_range = linspace(0.45,8,resolution);
slab_thicknesses = zeros(size(slab_range));

for i = 1:length(cyl_range)
    cyl_radius = cyl_range(i)/2;
    cyl_radii(i) = scratch_pad15(theta_ign, cyl_radius,table);
    thickness = slab_range(i);
    slab_thicknesses(i) = scratch_pad16(theta_ign, thickness);
end

figure(88); clf;
plot(cyl_range,cyl_radii,'b-');
hold on
plot(slab_range, slab_thicknesses, 'r:');

figure(89); clf;
plot(cyl_radii,cyl_range,'b-');
hold on
plot(slab_thicknesses,slab_range, 'r:');
% 
% figure(90); clf;
% plot(cyl_radii,cyl_range./slab_range,'k-');
C = interpolate(0.5, cyl_radii, cyl_range);
S = interpolate(0.5, slab_thicknesses, slab_range);
ratio = C/S;