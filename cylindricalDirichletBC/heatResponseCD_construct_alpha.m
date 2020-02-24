% Generate table of bessel roots (for caching). Used as input argument
%   to heatRespondCD_polar
%  -M: max m
%  -N: max n
%  return: array M+1 x N

function value = heatResponseCD_construct_alpha(M,N)
table_dt = 1;
alpha = zeros(M+1,N);
for m = 0:M
    % Linear search for bisection interval
    t_low = table_dt;
    t_high = 2*table_dt;
    for n = 1:N
        while besselj(m,t_low)*besselj(m,t_high) > 0
            t_high = t_high + table_dt;
        end
        % Store alpha_{m,n} in alpha(m+1,n)
        alpha(m+1,n) = fzero(@(x)besselj(m,x), [t_low t_high]);
        % Approximate pi spacing
        t_low = alpha(m+1,n) + pi - 1.5;
        t_high = alpha(m+1,n) + pi + 1.5;
    end
end
value = alpha;