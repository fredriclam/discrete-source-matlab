% Returns response of heat equation to boxcar function with duration tau_c
% and unit area under the curve. Index 0 indicates zeroth derivative
% Input:
%   tauc: duration of boxcar
%   pos: position at which response is determined, [x y z] or [x y]
%   pos_source: position of source, [x y z] or [x y]
%   t: time
%   t_source: time of source igntion

function G = heatResponse_0(tauc,pos,pos_source,t,t_source)
% Dimensionality
dim = length(pos);
if length(pos) ~= length(pos_source)
    error('Dimension of position vectors not equal')
end

% Compute delta_t
delta_t = t - t_source;
if delta_t <= 0
    G = 0;
    return
end

% Compute r2
r2 = dot(pos - pos_source, pos - pos_source);
if r2 == 0
    G = Inf;
    return
end

switch dim
    % 1D code
    case 1
        % Dirac delta
        if tauc == 0
            G = exp(-r2./ (4*delta_t)) ./ sqrt(4*pi*delta_t);
            return
        end
        % Boxcar
        r = sqrt(r2);
        if delta_t > tauc
            firstTerm = sqrt((delta_t - tauc)/pi) * ... 
                exp(-r2./(4*(delta_t-tauc))) - ...
                r/2*erfc(r./(2*sqrt(delta_t-tauc)));
        else
            firstTerm = 0;
        end
        G = (sqrt(delta_t ./ pi) * exp(-r2/(4*delta_t)) - ...
            r/2 * erfc(r/(2*sqrt(delta_t))) - ...
            firstTerm) / tauc;
        return
    case 2
        % Dirac delta
        if tauc == 0
            G = exp(-r2./ (4*delta_t)) ./ (4*pi*delta_t);
            return
        end
        % Boxcar
        if delta_t > tauc
            firstTerm = ei(-r2./(4*(delta_t-tauc)));
        else
            firstTerm = 0;
        end
        G = ( firstTerm - ei(-r2 ./ (4*delta_t))) ...
            ./ (4*pi*tauc);
        return
    case 3
        % Dirac delta
        if tauc == 0
            G = exp(-r2./ (4*delta_t)) ...
                ./ (4*pi*delta_t) ./ sqrt(4*pi*delta_t);
            return
        end
        % Boxcar
        r = sqrt(r2);
        if delta_t > tauc
            firstTerm = erfc(r./(2*sqrt(delta_t-tauc)));
        else
            firstTerm = 0;
        end
        G = ( erfc(r./ (2*sqrt(delta_t))) - firstTerm ) ...
            ./ (4*pi*r*tauc);
        return
    otherwise
        error('1D, 2D, or 3D position arguments accepted only')
end
