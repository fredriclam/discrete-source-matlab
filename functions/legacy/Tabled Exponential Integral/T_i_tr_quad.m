function output = T_i_tr_quad(t, r2, tr, lookup, dq, q_max)
    if t <= tr
        output = -tei_quad(-0.25*r2/t,lookup, dq, q_max);
        % Reacting case
    else
        output = tei_quad(-0.25*r2/(t-tr),lookup, dq, q_max) -...
            tei_quad(-0.25*r2/t,lookup, dq, q_max);
        % Cooling case
    end
    output = output / 4 / pi / tr;