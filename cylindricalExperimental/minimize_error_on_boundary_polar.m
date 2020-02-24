% Script to minimize error on boundary (L2 average on r = 1, averaged on t)
%   Brute force

% Source position
x_source = 0.3;
y_source = 0.65;
t = 0.1; % Magically 0.1 works best, at least for the square case
RES = 3* 9;
% Search space
x0_vector = linspace(-3, 3, RES);
% y0_vector = linspace(-1, 2, 10);
y0_vector = linspace(-3, 3, RES);
e_L2_matrix = nan(length(x0_vector), length(y0_vector), ...
    length(x0_vector), length(y0_vector));

% Functions
fixed_particle = @(x,y) heatResponse_0(0, [x y], ...
    [x_source y_source], t, 0);
moving_particle = @(x,y,x0,y0) -heatResponse_0(0, [x y], [x0 y0], t, 0);

% Loop
for i = 1:length(x0_vector)
    for j = 1:length(y0_vector)
        for k = 1:length(x0_vector)
            for l = 1:length(y0_vector)
                x0(1) = x0_vector(i);
                y0(1) = y0_vector(j);
                x0(2) = x0_vector(k);
                y0(2) = y0_vector(l);
        
                % If in circle
                if x0(1)^2 + y0(1)^2 < 1 || ...
                    x0(2)^2 + y0(2)^2 < 1
                    e_L2_matrix(i,j) = nan;
                % Overlapping sources
                elseif x0(1) == x0(2) && y0(1) == y0(2)
                    e_L2_matrix(i,j) = nan;
                else
                    fxy = @(x,y) fixed_particle(x,y) + ...
                        moving_particle(x,y,x0(1),y0(1)) + ...
                        moving_particle(x,y,x0(2),y0(2));
                    e_L2_matrix(i,j,k,l) = error_on_boundary_polar(fxy);
                end
            end
        end
    end
end

e_L2_matrix_reduced = min(min(e_L2_matrix,[],3),[],4);

%% Plotting
clf;
contourf(x0_vector, y0_vector , e_L2_matrix_reduced')
colorbar;
hold on;
plot(x_source, y_source, 'x', 'MarkerSize', 24);
axis equal;

%% Find minimizing positions
[I J] = find(e_L2_matrix_reduced == min(min(e_L2_matrix_reduced)));
for k = 1:length(I)
    i = I(k);
    j = J(k);
    
    [ii jj] = find(squeeze(e_L2_matrix(i,j,:,:)) == ...
        min(min(squeeze(e_L2_matrix(i,j,:,:)))));
    
    plot(x0_vector(i), y0_vector(j), '.r', 'MarkerSize', 24)
    plot(x0_vector(ii(1)), y0_vector(jj(1)), '.r', 'MarkerSize', 24)
end