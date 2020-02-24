function value = ICHR_IPR(r, r0, diff_t, diff_th, diff_z, b, M, N, alpha)

value = 0;
for m = 0:M
    term = a_k(b,alpha,m,N,diff_t,r,r0);
    if m == 0
        term = term/2;
    else
        term = term * cos(m*diff_th);
    end
    value = value + term;
end

coeff = 1/pi/sqrt(pi)/b^2;
value = coeff ...
    / sqrt(diff_t) ...
    * exp(-diff_z.^2/4./diff_t) ...
    * value;

% Given m
function value = a_k(b,alpha,m,N,diff_t,r,r0)

r_func = @(R) 0.5*b*(R+1);
R_func = @(r) 2/b*r - 1;
P = zeros(N,N);

% Fill matrix
for n = 1:N
    norm = 0.5*b^2*(besselj(m+1,alpha(m+1,n)))^2;
    coeff = 0.5*b/norm;
    % Compute Gegenbauer l components
    for l = 1:N
        f = @(R) r_func(R).*...
            gegenbauer(l,R).*...
            besselj(m,alpha(m+1,n)/b*r_func(R));
        S = integral(f, -1, 1);
        P(n,l) = coeff*S;
    end
end

% Fill original coefficients vector
a = zeros(N,1);

for n = 1:N
    xi = alpha(m+1,n)/b;
    a(n) = exp(-xi^2*diff_t)...
        * besselj(m, xi*r0) / ...
        (bessel_derivative(m, xi*b))^2;
end

g = P\a;
value = 0;
for l = 1:N
    value = value + g(l)*gegenbauer(l,R_func(r));
end

function value = bessel_derivative(m, arg)
if m == 0
    value = -besselj(1,arg);
elseif m > 0
    value = 0.5*(besselj(m-1,arg) - besselj(m+1,arg));
else
    error 'wtf';
end
return

function value = gegenbauer(i,x)
xi = 0.5;
if i == 0
    value = 1;
elseif i == 1
    value = 2*xi*x;
else
    value = 1/i*(...
        2*(i+xi-1)*x.*gegenbauer(i-1,x) - ...
        (i+2*xi-2)*gegenbauer(i-2,x) ...
    );
end