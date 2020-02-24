function output = tei_boss(q, lookup, dq, q_max)
if q > 0
    output = 0;
elseif abs(q) > abs(q_max)
    output = 0;
%     disp 'OOR';
elseif q > -0.15 % q > -0.2 good; tuning to -0.15 works even better
    output = double(eulergamma) + log(abs(q)) +...
    q + q.^2/4 + q.^3/18 + q.^4/96 + q.^5/600;
else
    i = floor(q/dq);
    % Interpolate:
    % MATLAB index...
    i = i + 1;
    % Starts from zero!
    q_node = (i-1)*dq;
%     % Snap approximation
%     output = lookup(2,i);
    % Interpolation proper
    output = lookup(2,i) + (q-q_node)*(lookup(2,i+1) - lookup(2,i))/dq;
end