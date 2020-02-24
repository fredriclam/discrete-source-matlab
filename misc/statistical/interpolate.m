function y = interpolate(x, x_vector, y_vector)

% Find x in x_vector
search = find(x_vector>=x);
if isempty(search) || search(1) == 1
    warning('In interpolate: Interpolation not possible.')
    y = nan;
    return
end
% First index
index = search(1);

dx = x_vector(index) - x_vector(index-1);
t = (x - x_vector(index-1)) / dx;
y = y_vector(index-1)*(1-t) + y_vector(index)*t;