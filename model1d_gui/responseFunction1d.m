% Returns temperature response of the field due to particle
function y = responseFunction1d(tauc, x0, t0, x, t)
% Remove singularity
if t < 1e-5
    y = zeros(size(x));
    return
end

% Compute response
if tauc == 0
    y = 1./sqrt(4*pi*(t-t0)) .* ...
        exp( - (x-x0).^2 ./ (4*(t-t0)) );
else
    r = abs(x-x0);
    y = sqrt((t-t0)/pi) .* exp(-r.^2 ./ (4*(t-t0))) - ...
        r/2 .* erfc(r./(2*sqrt(t-t0)));
    if t > t0 + tauc + 0.01
        y = y - ...
            (sqrt((t-t0-tauc)/pi) .* exp(-r.^2 ./ (4*(t-t0-tauc)))-...
            r/2 .* erfc(r./(2*sqrt(t-t0-tauc))));
    end
    y = y / tauc;
end