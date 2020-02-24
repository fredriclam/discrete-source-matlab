% Eigenfunction expansion in isothermal cylinder heat release function.
% Intermediate function called by heatResponseCD_polar
%  -r: target coordinate r
%  -r0: source coordinate r0
%  -diff_t: t-t0
%  -diff_th: theta-theta0
%  -b: cylinder radius
%  -M: max summation index m
%  -N: max summation index n
%  -alpha: besselj roots table (generated by
%    heatResponseCD_construct_alpha)
%  return: eigenfunction expansion (finite sum)

function value = heatResponseCD_summation(r, r0, diff_t, diff_th, b, M, ...
    N, alpha)
% Reduce
value = 0;
table = zeros(M+1,N); % Debug saved values
for m = 0:M
    for n = 1:N
        table(m+1,n) = heatResponseCD_term(r, r0, diff_t, diff_th, b, m, n,alpha);
        value = value + table(m+1,n);
    end
end
% disp(table);