% Error on boundary of unit circle

function integ_on_bdry = error_on_boundary_polar(fxy)
integ_on_bdry = 0;
res = 50;
% d \theta
dth = 2*pi/res;

for i = 1:res
    th = i*dth;
    integ_on_bdry = integ_on_bdry + fxy(cos(th),sin(th)).^2 * dth; 
end