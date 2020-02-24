% Unpacks data structs (e.g. Q64, R10) to a bunch of vectors in the
% workspace for plotting.

% Packed data version
Q = Q64;

for i = 1:length(Q)
    eval_string = [...
        'Z_' num2str(Q(i).tauc*1e2) 'x' num2str(Q(i).tign*1e3) '_t' ...
        ' = log(Q(i).t); ' ...
        'Z_' num2str(Q(i).tauc*1e2) 'x' num2str(Q(i).tign*1e3) '_W' ...
        ' = log(Q(i).W); '];
    eval(eval_string);
end