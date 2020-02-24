% Returns d/dt of response of heat equation to boxcar function with
% duration tau_c and unit area under the curve. Index 1 indicates first
% derivative.
% Input:
%   tauc: duration of boxcar
%   pos: position at which response is determined, [x y z] or [x y]
%   pos_source: position of source, [x y z] or [x y]
%   t: time
%   t_source: time of source igntion

function G = heatResponse_1(tauc,pos,pos_source,t,t_source)
% Dimensionality
dim = length(pos);
if length(pos) ~= length(pos_source)
    error('Dimension of position vectors not equal')
end

% Compute delta_t
delta_t = t - t_source;
if delta_t <= 0
    G = NaN;
    return
end

% Compute r2
r2 = dot(pos - pos_source, pos - pos_source);
if r2 == 0
    G = NaN;
    return
end

switch dim
    % 3D code
    case 3
        % Dirac delta
        if tauc == 0
            G = -(exp(-r2./(4*delta_t)).*(6*delta_t - r2)) ./ ...
                (32*delta_t^(7/2)*pi^(3/2));
            return
        end
        % Boxcar
        r = sqrt(r2);
        if delta_t > tauc
            firstTerm = r * exp(-r2/(4*(delta_t-tauc))) ./ ...
                (2*(delta_t-tauc)*sqrt((delta_t-tauc)*pi));
        else
            firstTerm = 0;
        end
        G = ( r * exp(-r2/(4*delta_t)) ./ ...
                (2*delta_t*sqrt(delta_t*pi)) - firstTerm ) ...
            ./ (4*pi*r*tauc);
        return
    otherwise
        error('Implementation: 3D position arguments accepted only')
end
