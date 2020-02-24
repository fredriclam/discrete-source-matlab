% Use bilinear interpolation on table to get value of shape function "phi"
% for sphere-in-cylinder case.
% argin:
%   a -- Standoff (sphere centre from cylinder axis)
%   s -- Sphere radius 
%   c -- Cylinder radius
%   table -- 2D interpolation table

function shape_value = get_shape_value(a,s,c,table)
% Renormalize with respect to c
a = a./c;
s = s./c;
% c = 1;
% Check table can handle this
% assert(Interp.s_min <= s && s <= Interp.s_max);
% assert(Interp.a_min <= a && a <= Interp.a_max);
% Find coordinates
coord_a = (a - table.a_min)/(table.a_max - table.a_min) *...
    (table.a_res-1) + 1;
coord_s = (s - table.s_min)/(table.s_max - table.s_min) *...
    (table.s_res-1) + 1;
index_a = floor(coord_a);
index_s = floor(coord_s);
% Bilinear interpolation
t = coord_a - index_a;
f_s0 = (1-t) * table.table(index_s,index_a) + ...
    t * table.table(index_s,index_a+1);
f_s1 = (1-t) * table.table(index_s+1,index_a) + ...
    t * table.table(index_s+1,index_a+1);
t = coord_s - index_s;
shape_value = (1-t) * f_s0 + t * f_s1;
end