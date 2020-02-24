% Need standard_table

theta_range = linspace(0.01,0.14,15);
ratio_range = zeros(size(theta_range));
C_range = ratio_range;
S_range = ratio_range;

for i = 1:length(theta_range)
    theta = theta_range(i);
    [ratio_range(i), C_range(i), S_range(i)] =  ...
        scratch_pad17(theta, standard_table);
end

figure(90000);
plot(theta_range, ratio_range)
figure(90001);
plot(theta_range,S_range);
hold on
plot(theta_range,C_range);