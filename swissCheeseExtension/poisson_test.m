% Test poisson distribution of points in uniform distribution onto a disk
% (2D): lambda = pi*1^2 (mean)
% PDF: lambda^n exp(-lambda) / factorial(n)

NUM_RUNS = 50000;
BBOX_radius = 50;
BBOX_count_max = 4*BBOX_radius^2;
result = zeros(BBOX_count_max+1,1);
for i = 1:NUM_RUNS
    x = -BBOX_radius + 2*BBOX_radius*rand(BBOX_count_max,1);
    y = -BBOX_radius + 2*BBOX_radius*rand(BBOX_count_max,1);
    result(sum(x.^2 + y.^2 < 1)+1) = result(sum(x.^2 + y.^2 < 1)+1) + 1;
end

plot(0:BBOX_count_max, result/NUM_RUNS)
hold on;
plot(0:BBOX_count_max, ...
    ...2*pi*exp(-pi*1^2*(0:BBOX_count_max))...
    (pi).^(0:BBOX_count_max) * exp(-pi)./factorial(0:BBOX_count_max)...
    , 'o');
    
xlim([0, 10])