% Impromptu code to draw the contourf and format. Used in L2_test for
% isothermal boundary conditions

function paint(x,y,z)

contourf(x,y,z,'LineStyle','None')
original_caxis = caxis;
% surf(grid_x,grid_y,u,'LineStyle','None')
hold on
% Zero finder
contour(x, y, z, [0, 0],...
'LineColor', [0 0 255]/255, ...
'LineWidth', 1);
% view([0, 90])
caxis(original_caxis);
colormap hot;
colorbar;
axis equal;
hold off;