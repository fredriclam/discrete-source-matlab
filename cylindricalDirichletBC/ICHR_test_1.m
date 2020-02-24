% Checking again to see if the cylindrical Dirichlet BCs can be correctly
% implemented. Method: contours testing the function on a Cartesian grid
% What happens: the cylinder is indeed at T = 0 (enforced by the scaled
% Bessel functions). Having more terms results in perturbations at small t

% Parameters
M = 4;
N = 4;
cyl_radius = 3;
res_x = 30;
res_y = 30;

% Grid
grid_x = linspace(0,1.1*cyl_radius,res_x);
grid_y = linspace(0,1.1*cyl_radius,res_y);
u = zeros(length(grid_y), length(grid_x));

% Source location
x0 = 1;
y0 = 2;
% Relative coordinates
diff_z = 1;
diff_t = 1;

% Build grid
for i = 1:length(grid_x)
    x = grid_x(i);
    for j = 1:length(grid_y)
        y = grid_y(j);
        % Convert to polar
        r = sqrt(x.^2 + y.^2);
        r0 = sqrt(x0.^2 + y0.^2);
        th = atan2(y,x);
        th0 = atan2(y0,x0);
        diff_th = th - th0;
        u(j,i) = ICHR_polar(r,r0,diff_t,diff_th,diff_z,cyl_radius,...
            M,N,ICHR_construct_alpha(M,N));
    end
end

%% Plotting

contourf(grid_x,grid_y,u,'LineStyle','None')
original_caxis = caxis;
% surf(grid_x,grid_y,u,'LineStyle','None')
hold on
% Zero finder
contour(grid_x, grid_y, u, [0, 0],...
        'LineColor', [0 0 255]/255, ...
        'LineWidth', 1);
% view([0, 90])
caxis(original_caxis);
colormap hot;
colorbar;
axis equal;
hold off;