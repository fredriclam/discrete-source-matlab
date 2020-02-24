% Implementation of the "hot gas" initial condition. Testing 2D, in
% cylindrical coordinates.

% Tried to inverse Hankel transform according to some table; incorrect!!
u = @(r,t,R) 0.5 * R / r / t * exp(-0.25*(r^2 + R^2)/t) * ...
    besseli(1,0.5*r*R/t);
% Numerical integration
integrand = @(rho,r,t,R) R .* besselj(1,rho.*R).* ...
    exp(-rho.^2 .* t) .* besselj(0,rho.*r);
u_int = @(r,t,R) integral(@(rho) integrand(rho,r,t,R),0,Inf);

R = 1;
% lz = 0.5;
% lx = 0.5;
% ly = 5;
% z = 0.25;

% General resolution
RES = 20;
RES_t = 10;
vector_x = linspace(0,2*R,RES)';
vector_y = linspace(0,2*R,RES)';
vector_t = linspace(0,.01,RES_t+1)'; vector_t = vector_t(2:end);
matrix_u = zeros(length(vector_x), length(vector_y), length(vector_t));

for k = 1:RES_t
    t = vector_t(k);
    for i = 1:length(vector_y)
        y = vector_y(i);
        for j = 1:length(vector_x)
            x = vector_x(j);
            matrix_u(i,j,k) = u_int(sqrt(x^2 + y^2), ...
                t, R);
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
    pause(0.2)
end

