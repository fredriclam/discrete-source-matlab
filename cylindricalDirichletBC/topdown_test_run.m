% Function for topdown_test.m
% Naive implementation

function t_ign = topdown_test_run(param, data)

% Unpack variables
M = param.M;
N = param.N;
dt = param.dt;
alpha_table = param.alpha_table;
source_count = param.source_count;
t_max = param.t_max;
cyl_radius = param.cyl_radius;
T_ign = param.T_ign;

t_ign = data.t_ign;
th = data.th;
r = data.r;
z = data.z;

% Global t
t = 0;
ignite_count = length(t_ign(t_ign<1e8));
while t < t_max && ignite_count < source_count;
    for i = 1:length(t_ign)
        % Check each unignited for ignition
        if t_ign(i) >= 1e8
            T = 0;
            % Sum contribution from ignited
            for j = 1:length(t_ign)
                if t > t_ign(j)
                    T = T + ...
                        heatResponseCD_polar(r(i),r(j),t-t_ign(j),th(i)-th(j), ...
                        z(i)-z(j),cyl_radius,M,N,alpha_table);
                end
            end
            % Ignition event
            if T > T_ign
                t_ign(i) = t;
                ignite_count = ignite_count + 1;
            end
        end
    end
    t = t + dt;
    % Console output
    disp(['M = ' num2str(M) ' N = ' num2str(N) ' t = ' num2str(t)]);
end