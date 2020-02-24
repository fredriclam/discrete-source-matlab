% Use bilinear interpolation on table to get value of shape function "phi"
% for sphere-in-cylinder case.
% argin:
%   a -- Standoff (sphere centre from cylinder axis)
%   s -- Sphere radius 
%   c -- Cylinder radius
%   table -- 2D interpolation table

function shape_value = get_shape_value_slab(standoff,r,thickness)
if r < 0
    warning('In stable_integrand.m : r < 0');
elseif r < standoff
    shape_value = 1;
elseif r < thickness-standoff
    shape_value = (1/2 + 1/2 * standoff ./ r);
else
    shape_value = (1/2 * thickness ./ r);
end
end