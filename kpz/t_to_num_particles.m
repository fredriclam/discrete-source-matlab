% Takes a vector of (averaged) ignition times ("table") where the index
% corresponds to the total number of ignited particles, and a time t;
% returns the total number of particles ignited at time t (exact, provided
% that the table is correctly derived from the log of ignition events).
%
% Input
%     table: vector of ignition (event) times
%     t: t
% Output
%     r: The number of particles ignited at time t

function r = t_to_num_particles(table, t)
if isrow(table)
    table = table';
end
[r, c] = find(table > t, 1);
if isempty(r)
    r = size(table,1);
end