function [out, i] = images_green_2d_diag_correct(x, y, t, L, tol)
% Limit override
if t == 0
    out = 0;
    i = 0;
    return
end
% 2D Green
G = @(x,y,t) 1 ./ (4*pi*(t)).^(2/2) .* exp(-((x).^2+y.^2)/(4*(t)));
i = 1;
out = G(x,y,t);
term = 0;
last_term = 10*tol;
while abs(term-last_term) > tol
    last_term = term;
    term = G(x,y+i*L,t) + G(x,y-i*L,t);
    out = out + term;
    i = i + 1;
    if i == 3
        break
    end
    assert(i<50)
end