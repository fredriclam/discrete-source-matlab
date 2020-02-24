% Note: standoff (sigma) is distance/"depth" from nearest edge
% Verified numerically: CDF = 1 from 0 to 10 @ thickness = 1, standoff =
% 0.3
function y_vector = stable_integrand(r_vector,thickness,standoff,PR)

y_vector = zeros(size(r_vector));

for i = 1:length(r_vector)
    r = r_vector(i);

    surface_area = 4*pi*r.^2;
    volume = 4/3*pi*r.^3;

    if r < 0
        warning('In stable_integrand.m : r < 0');
        y = 0;
    elseif r < standoff
        y = 0.5 .* surface_area .* ...
            exp(-0.5 * volume .* PR);
    elseif r < thickness-standoff
        y = (1/6*standoff ./ r + 1/4) .* surface_area .* ...
            exp(-0.5 * (1/2 + 1/2 * standoff ./ r) .* volume .* PR);
    else
        y = (1/6*thickness ./ r) .* surface_area .* ...
            exp(-0.5 * (1/2 * thickness ./ r) .* volume .* PR);
    end
    y_vector(i) = y;
end



return