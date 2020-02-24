% Generate 2D table of data of shape function "phi" for sphere-in-cylinder
% case by wrapping monte_carlo_sphere.m

function table = Interp_Shape_Cyl()
table.a_min = 0;
table.a_max = 1.02;
table.a_res = 50;
table.s_min = 0;
table.s_max = 5;
table.s_res = 500;
% Build shape function of sphere
table.s_range = linspace(table.s_min,table.s_max,...
    table.s_res);
table.a_range = linspace(table.a_min,table.a_max,...
    table.a_res);
table.table = zeros(length(table.s_range),...
    length(table.a_range));

% Shuffle RNG
rng('shuffle');
% Develop basic data table
for i = 1:length(table.s_range)
    s = table.s_range(i);
    for j = 1:length(table.a_range)
        a = table.a_range(j);
        table.table(i,j) = monte_carlo_sphere(a,s,1);
    end
end
end