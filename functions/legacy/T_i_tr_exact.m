% Returns finite reaction-time temperature contribution of a 2D spatial
% Green's function to the diffusion equation (unit integral weight).

function output = T_i_tr_exact(t, r2, tr)
    if t <= tr
        output = -ei(-0.25*r2./t);
        % Reacting case
    else
        output = ei(-0.25*r2./(t-tr)) - ei(-0.25*r2./t);
        % Cooling case
    end
    output = output ./ 4 ./ pi ./ tr;