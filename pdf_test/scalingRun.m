% Runs discrete source propagation in MATLAB
% Naive implementation

function [t_ign, distances, contributions] = scalingRun(param, data)

% Unpack variables
dt = param.dt;
source_count = param.source_count;
t_max = param.t_max;
T_ign = param.T_ign;
tauc = param.tauc;

x = data.x;
y = data.y;
z = data.z;
t_ign = data.t_ign;
id = (1:length(t_ign))';

final_tol = 1e-9;

% Global t
t = 0;
% Last ignition event (for root-finding)
t_last = 0;
ignite_count = length(t_ign(t_ign<1e8));
% Initialize data structures for contribution information (for PDF)
NUM_NEIGHBOURS = 50;
for i = 1:NUM_NEIGHBOURS
    distances(i) = Vector;
    contributions(i) = Vector;
end

while t < t_max && ignite_count < source_count;
    for i = 1:length(t_ign)
        % Check each unignited for ignition
        if t_ign(i) >= 1e8
            T = 0;
            % Sum contribution from ignited
            for j = 1:length(t_ign)
                if t > t_ign(j)
                    T = T + ...
                        heatResponse_0(tauc,[x(i), y(i), z(i)],...
                        [x(j), y(j), z(j)],t,t_ign(j));
                end
            end
            % Ignition event
            if T > T_ign
                % Root-finding for precision
                t_lower = max(t_last, t-dt);
                t_upper = t;
                t_search = 0.5*(t_lower + t_upper);
                while t_upper - t_lower > final_tol
                    % Calculate T
                    T = 0;
                    for j = 1:length(t_ign)
                        if t > t_ign(j)
                            T = T + ...
                                heatResponse_0(tauc,[x(i), y(i), z(i)],...
                                [x(j), y(j), z(j)],t_search,t_ign(j));
                        end
                    end
                    if T > T_ign
                        t_upper = t_search;
                    else
                        t_lower = t_search;
                    end
                    t_search = 0.5*(t_lower + t_upper);
                end
                % Save last t
                t_last = t;
                % Set t to the found t_search
                t = t_search;
                
                % Set ignition
                t_ign(i) = t;
                ignite_count = ignite_count + 1;
                % Recalculate contributions
                % Filter relative distance of other sources
                r_rel = sqrt((x-x(i)).^2 + (y-y(i)).^2 + (z-z(i)).^2);
                % Sort and filter for ignited particles only
                temp_array = sortrows([r_rel(t_ign < t), id(t_ign < t)]);
                r_rel = temp_array(:,1);
                indexed = temp_array(:,2);
                % Log PDF information
                for k = 1:NUM_NEIGHBOURS
                    if k > length(r_rel)
                        distances(k).append(NaN);
                        contributions(k).append(0);
                        continue
                    end
                    % Ignore first entry, which is particle i itself (r=0)
                    distances(k).append(r_rel(k));
                    this_contribution = heatResponse_0(tauc,...
                        [x(i), y(i), z(i)],...
                        [x(indexed(k)), ...
                        y(indexed(k)), ...
                        z(indexed(k))], ...
                        t, t_ign(indexed(k))) ...
                        / T_ign;
                    assert(this_contribution <= 5.);
                    contributions(k).append(this_contribution);
                end
            end
        end
    end
    t = t + dt;
    % Console output
    disp(['t =' num2str(t)]);
end