% Checking again to see if the cylindrical Dirichlet BCs can be correctly
% implemented. Method: checking convergence in some L2 norm. If it
% converges reasonably, some average may be taken (FFT?)

% Parameters
M = 7;
N = 3;
for m = 1:M
    for n = 1:N
        disp(['m = ' num2str(m) ' n = ' num2str(n)]);
        cyl_radius = 3;
        res_x = 24;
        res_y = 24;
        
        % Grid
        grid_x = linspace(0,1.1*cyl_radius,res_x);
        grid_y = linspace(0,1.1*cyl_radius,res_y);
        u = zeros(length(grid_y), length(grid_x));
        
        % Source location
        x0 = 1;
        y0 = 2;
        % Relative coordinates
        diff_z = 1;
        diff_t = 0.1;
        
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
                u(j,i) = heatResponseCD_polar(r,r0,diff_t,diff_th,diff_z,cyl_radius,...
                    m,n,heatResponseCD_construct_alpha(m,n));
            end
        end
        u_tot(:,:,m,n) = u;
        
        % Plotting
        subplot(M,N,(m-1)*N+n);
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
        
        % Tracking
        pointwise(m,n) = heatResponseCD_polar(2,sqrt(5),diff_t,-1.1071,1,cyl_radius,...
                    m,n,heatResponseCD_construct_alpha(m,n));
        dx = 1.1*cyl_radius/res_x;
        dy = 1.1*cyl_radius/res_y;
        norm_L2(m,n) = sum(sum(u)) * dx * dy;
    end
end


%% Process Fejer averaging (Cesaro filtering)
fav = u_tot(:,:,:,3);
for i = size(fav,3):-1:1
    fav(:,:,i) = sum(fav(:,:,1:i),3) ./ i;
end