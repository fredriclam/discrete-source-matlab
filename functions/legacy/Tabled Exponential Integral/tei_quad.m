function output = tei_quad(q, lookup, dq, q_max)
if q > 0
    output = 0;
elseif abs(q) > abs(q_max)
    output = 0;
    disp 'OOR';
else
    i = floor(q/dq);
    % Interpolate:
    % MATLAB index...
    i = i + 1;
    if i == 1
        disp 'Zero-argument singularity';
        q_node = (i-1)*dq;
        output = lookup(2,i) + (q-q_node)*(lookup(2,i+1) - lookup(2,i))/dq;
        return
    elseif i >= length(lookup)-1
        disp 'End-value of table';
        output = 0;
        return
    end
    
    
    % Starts from zero!
    q_1 = (i-1)*dq; % Nearest (floored) value

    y1 = lookup(2,i);
    y0 = lookup(2,i-1);
    y2 = lookup(2,i+1);
    
    D1 = q-q_1;
    D0 = D1+dq;
    D2 = D1-dq;
    
    output = 1/2/dq^2 * (y0*D1*D2 - 2*y1*D0*D2 + y2*D0*D1);
end