% Generates tomographic map of isothermal-wall cylinder
function isothermal_cylinder

x_min = -1;
x_max = 1;
y_min = -1;
y_max = 1;
z_min = 0;
z_max = 1;
linear_res = 101;
tomo_res = 11;

% Cylinder size
b = 1;

% Source
r_0 = 0.5;
th_0 = 0;
z_0 = 0;
t_0 = 0;

% Time
t = 0.1;

% Memory allocation
x_range = linspace(x_min,x_max,linear_res);
y_range = linspace(y_min,y_max,linear_res);
z_range = linspace(z_min,z_max,tomo_res);
tome = zeros(linear_res, linear_res);

for k = 1:tomo_res
    z = z_range(k);
    for i = 1:linear_res
        x = x_range(i);
        for j = 1:linear_res
            y = y_range(j);
            % Translate into polar
            r = sqrt(x.^2 + y.^2);
            th = atan2(y, x);
            % Get value
            tome(i,j,k) = cylinder_thermal_function(...
                r, th, z, t, r_0, th_0, z_0, t_0, b);
            % Residual relative to free-space Green's function in 3D
            %             - 1/(4*pi*(t-t_0))^(3/2)*exp(-((x-r_0)^2 + ...
            %                 (y)^2 + (z-z_0)^2)/(4*(t-t_0)));
        end
    end
end

% Zero outsides
% for i = 1:size(tome,1)
%     for j = 1:size(tome,2)
%         for k = 1:size(tome,3)
%             if tome(i,j,k) < 0
%                 tome(i,j,k) = 0;
%             end
%         end
%     end
% end

contourf(x_range, y_range, tome);
max_value = max(max(tome));
caxis([0 max_value]);
    colormap hot;
colorbar;
