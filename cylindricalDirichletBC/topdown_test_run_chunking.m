% Function for topdown_test.m
% Features 2 local chunks of the domain that contribute to propagation;
% lagging chunk contributes to the forward chunk, and the forward chunk
% contributes to itself; thus, ignition is only checked in the forward
% (active) chunk

function t_ign = topdown_test_run_chunking(param, data)

% Unpack variables
M = param.M;
N = param.N;
dt = param.dt;
source_count = param.source_count;
t_max = param.t_max;
T_ign = param.T_ign;
alpha_table = param.alpha_table;
cyl_radius = param.cyl_radius;

% Data table Q
r = data.r;
th = data.th;
z = data.z;
t_ign = data.t_ign;
id = 1:length(t_ign);

% Chunk parameters
chunk_size = 8;
chunk_advance_ratio = 0.5;
chunk_forward_limit = 0.75;

% Initialize
t = 0;
ignite_count = length(t_ign(t_ign<1e8));
chunk_border = 0; % Centre chunks on front
% Init chunk (do not advance)
[chunk_border, chunk_active, chunk_pushing, cross_table, delta_z_table] = ...
    update_chunks(chunk_border, chunk_size, 0, r, th, z, t_ign, id, param);

while t < t_max && ignite_count < source_count;
    for index_unign = chunk_active
        % Check each unignited for ignition
        if t_ign(index_unign) >= 1e8
            T = compute_contribution(index_unign, chunk_active, ...
                chunk_pushing, cross_table, delta_z_table, t, t_ign, param);
            if T >= T_ign
                t_ign(index_unign) = t;
                ignite_count = ignite_count + 1;
            end
        end
    end
    % Update chunks
    front_pos = max(z(t_ign < 1e8));
    if front_pos > chunk_border + chunk_forward_limit * chunk_size
        [chunk_border, chunk_active, chunk_pushing, cross_table, delta_z_table] = ...
            update_chunks(chunk_border, chunk_size, chunk_advance_ratio, r, th, z, t_ign, id, param);
    end
    
    t = t + dt;
    % Console output
%     disp(['M = ' num2str(M) ' N = ' num2str(N) ' t = ' num2str(t)]);
end

function T = compute_contribution(index_unign, chunk_active, ...
                chunk_pushing, cross_table, delta_z, t, t_ign, param)
T = 0;
for m = 0:param.M
    for n = 1:param.N
        % Get vector of relevant particles
        vector_t_ign = t_ign([chunk_active, chunk_pushing]);
        vector_delta_t = (t - vector_t_ign(vector_t_ign < 1e8))';
        xi = param.alpha_table(m+1,n)/param.cyl_radius;
        
        mapped_index = find(chunk_active==index_unign);
        vector_cross_table = cross_table(mapped_index,:,m+1,n);
        
        vector_delta_z = delta_z(mapped_index,:);
        
        % Filter
        vector_cross_table = vector_cross_table(vector_t_ign < 1e8);
        vector_cross_table = vector_cross_table(vector_delta_t > 0);
        vector_delta_z = vector_delta_z(vector_t_ign < 1e8);
        vector_delta_z = vector_delta_z(vector_delta_t > 0);
        vector_delta_t = vector_delta_t(vector_delta_t > 0);
        
        T = T + dot(exp(-xi.^2*vector_delta_t) ...
            ./ sqrt(vector_delta_t) .* ...
            exp(-vector_delta_z.^2/4./vector_delta_t), ...
            vector_cross_table);
    end
end
T = T /pi/sqrt(pi)/param.cyl_radius^2;

function [chunk_border, chunk_active, chunk_pushing, cross_table, delta_z_table] = ...
    update_chunks(chunk_border, chunk_size, chunk_advance_ratio, r, th, z, t_ign, id, param)
% Update chunk position
chunk_border = chunk_border + chunk_advance_ratio * chunk_size;
% Active chunk indices
chunk_active = id(z >= chunk_border & z <= chunk_border + chunk_size);
% Pushing chunk indices (ignited only)
chunk_pushing = id(z > chunk_border - chunk_size & z < chunk_border & ...
    t_ign < 1e8);

% Build cross_table
cross_table = zeros(length(chunk_active), ...
    length(chunk_active) + length(chunk_pushing), ...
    param.M, ...
    param.N);
delta_z_table = zeros(length(chunk_active), ...
    length(chunk_active) + length(chunk_pushing));
% Active site coefficients
for i = 1:size(cross_table, 1)
    for j = i+1:size(cross_table, 1)
        % Cross table coefficients
        for m = 0:param.M
            for n = 1:param.N
                % Compute coefficients
                xi = param.alpha_table(m+1,n)/param.cyl_radius;
                cross_table(i,j,m+1,n) = ...
                    besselj(m,xi*r(chunk_active(i))) * ...
                    besselj(m,xi*r(chunk_active(j))) / ...
                    (besselj(m+1, param.alpha_table(m+1,n))).^2 * ...
                    ... bessel_derivative(m, param.alpha_table(m+1,n)).^2 * ... incorrect
                    cos(m*(th(chunk_active(i))-th(chunk_active(j))));
                if m == 0 % Important! m = 0 case
                    cross_table(i,j,m+1,n) = cross_table(i,j,m+1,n)/2;
                end
            end
        end
        % Delta z table
        delta_z_table(i,j) = z(chunk_active(i)) - z(chunk_active(j));
    end
    % Copy across diagonal
    for j = 1:i-1
        for m = 0:param.M
            for n = 1:param.N
                cross_table(i,j,m+1,n) = cross_table(j,i,m+1,n);
            end
        end
        delta_z_table(i,j) = delta_z_table(j,i);
    end
end
% Push site coefficients
for i = 1:size(cross_table, 1)
    for j = size(cross_table, 1)+1:size(cross_table, 2)
        % Cross table coefficients
        for m = 0:param.M
            for n = 1:param.N
                % Compute coefficients
                xi = param.alpha_table(m+1,n)/param.cyl_radius;
                cross_table(i,j,m+1,n) = ...
                    besselj(m,xi*r(chunk_active(i))) * ...
                    besselj(m,xi*r(chunk_pushing(j-size(cross_table, 1)))) / ...
                    bessel_derivative(m, param.alpha_table(m+1,n)).^2 * ...
                    cos(m*(th(i)-th(j)));
                if m == 0 % Important! m = 0 case
                    cross_table(i,j,m+1,n) = cross_table(i,j,m+1,n)/2;
                end
            end
        end
        % Delta z table
        delta_z_table(i,j) = z(chunk_active(i)) - z(chunk_pushing(j-size(cross_table,1)));
    end
end

% function value = ICHR_term(r, r0, diff_t, diff_th, b, m, n, alpha)
% al = alpha(m+1,n);
% xi = al/b;
% value = besselj(m,xi*r0) ...
%         * besselj(m,xi*r) ...
%         / (bessel_derivative(m, al)).^2 ...
%         * exp(-xi.^2*diff_t) ...
%         * cos(m*diff_th);



function value = bessel_derivative(m, arg)
if m == 0
    value = -besselj(1,arg);
elseif m > 0
    value = 0.5*(besselj(m-1,arg) - besselj(m+1,arg));
else
    error 'wtf';
end
return