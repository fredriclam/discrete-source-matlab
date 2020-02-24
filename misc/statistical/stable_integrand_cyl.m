% Note: standoff (sigma) is distance/"depth" from nearest edge
% Verified numerically: CDF = 1 from 0 to 10 @ thickness = 1, standoff =
% 0.3
function y_vector = stable_integrand_cyl(r_vector,diameter,standoff,PR,...
    table)

% Finite differencing
dr = 0.001;

y_vector = zeros(size(r_vector));

for i = 1:length(r_vector)
    r = r_vector(i);

    surface_area = 4*pi*r.^2;
    volume = 4/3*pi*r.^3;

    if r < 0
        warning('In stable_integrand_cyl.m : r < 0');
        y = 0;
    else
        phi = get_shape_value(diameter/2-standoff, r, diameter/2, table);
        phi2 = get_shape_value(diameter/2-standoff, r+dr, diameter/2,table);
        dphi = (phi2-phi)/dr;
        y = 0.5 * (phi * surface_area + volume * dphi) .* ...
            exp(-0.5 * phi .* volume .* PR);
    end
    y_vector(i) = y;
end



return