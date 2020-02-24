% Zero-burn-tine 2D green's function for the diffusion equation with unit
% coefficients

function out = Green1Image(x, y, t, x0, y0, t0, L)
% Limit override
if t == 0
    out = 0;
    return
end
% 2D Green
G = @(x1,y1,t1) 1 ./ (4*pi*(t1-t0)).^(2/2) .* exp(-((x1-x0).^2+(y1-y0).^2)/(4*(t1-t0)));
out = G(x,y,t) + G(x,y - L,t) + G(x,y + L,t); % ...
%     + G(x,y + 2*L,t) + G(x,y - 2*L,t) ...
%     + G(x,y + 3*L,t) + G(x,y - 3*L,t);