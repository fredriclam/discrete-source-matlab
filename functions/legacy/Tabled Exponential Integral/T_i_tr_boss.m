function output = T_i_tr_boss(t, r2, tr, lookup, dq, q_max)
    if t <= tr
        output = -tei_boss(-0.25*r2/t,lookup, dq, q_max);
        % Reacting case
    else
        output = tei_boss(-0.25*r2/(t-tr),lookup, dq, q_max) -...
            tei_boss(-0.25*r2/t,lookup, dq, q_max);
        % Cooling case
    end
    output = output / 4 / pi / tr;