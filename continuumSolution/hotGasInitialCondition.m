% Implementation of the "hot gas" initial condition. Testing out for 3D,
% "reduced" to 2D by ignoring a factor.

% l - length of box bounding the hot gas
factor_xl = @(x,l,t) erf((x-0)/sqrt(4*t)) - erf((x-l)/sqrt(4*t));
u = @(x,y,z,lx,ly,lz,t) 0.125 * factor_xl(x,lx,t) * ...
    factor_xl(y,ly,t) * factor_xl(z,lz,t);

lz = 0.5;
lx = 0.5;
ly = 5;
z = 0.25;

% General resolution
RES = 100;
RES_t = 100;
vector_x = linspace(0,5,RES)';
vector_y = linspace(0,5,RES)';
vector_t = linspace(0,.1,RES_t+1)'; vector_t = vector_t(2:end);
matrix_u = zeros(length(vector_x), length(vector_y), length(vector_t));

for k = 1:RES_t
    t = vector_t(k);
    for i = 1:length(vector_y)
        y = vector_y(i);
        for j = 1:length(vector_x)
            x = vector_x(j);
            matrix_u(i,j,k) = u(x,y,z,lx,ly,lz,t);
        end
    end
end
%% Plot
for k = 1:RES_t
    contourf(vector_x, vector_y, matrix_u(:,:,k),'LineStyle','None')
    colormap hot;
    colorbar;
    caxis([0, 1]);
    title (['t = ' num2str(vector_t(k),'%.2f')]);
    pause(0.1)
end

