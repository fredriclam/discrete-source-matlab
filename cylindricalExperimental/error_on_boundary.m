% Error on boundary of unit square

function integ_on_bdry = error_on_boundary(fxy)
integ_on_bdry = ...
    gauss_quad(@(x) fxy(x, 0)^2, 0, 1) + ... top and bottom (1/2)
    gauss_quad(@(x) fxy(x, 1)^2, 0, 1) + ... top and bottom(2/2)
    gauss_quad(@(y) fxy(0, y)^2, 0, 1) + ...
    gauss_quad(@(y) fxy(1, y)^2, 0, 1);

function I = gauss_quad(f, a, b)

aff_trans = @(x) 0.5*(a+b) + 0.5*(b-a)*x;
quad_determinant = 0.5*(b-a);

w = [0.417959183673469
   0.381830050505119
   0.381830050505119
   0.279705391489277
   0.279705391489277
   0.129484966168870
   0.129484966168870];
x = [                0
   0.405845151377397
  -0.405845151377397
  -0.741531185599394
   0.741531185599394
  -0.949107912342758
   0.949107912342758];
cumulative = 0;
for i = 1:length(x)
    cumulative = cumulative + w(i) * f(aff_trans(x(i)));
end

I = quad_determinant * cumulative;