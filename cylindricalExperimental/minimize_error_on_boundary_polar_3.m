% Script to minimize error on boundary (L2 average on r = 1, averaged on t)
%   Monte carlo + MATLAB's simplex optimization
%   Symmetric
%   Can extend this to matching the Fourier-Bessel series solution in the
%   domain?
%   N.B. the objective function is actually the square of the L2 error
%   Only one parameter (r) needed to be adjusted for

% Source position
x_source = 0.;
y_source = 0.;
th0 = cart2pol(x_source,y_source);
results = [];

% Spiral distributor
best = 9999;
while best > 1e-7
    % Shake the box
    u0 = [];
    
    % Sources
    %     minus_sources = randi([3 8],1);
    plus_sources = randi([0 5],1); % pair(s)
    minus_sources = randi([0 5],1); % pair(s)
    
    num_sources = plus_sources + minus_sources;
    
    for i = 1:num_sources
        rr = 1 + i*rand(1);
        th = pi*rand(1);
        u0 = [u0 rr th];
    end
    
    % options = optimset('Display','iter','PlotFcns',@optimplotfval);
    options = optimset('Display','final',...
        'PlotFcns',@optimplotfval,...
        'MaxFunEvals', 750, ...
        'MaxIter', 500, ...
        'TolX', 1e-4, ...
        'TolFun', 1e-4 ...
        );
    
    if isempty(u0)
        u = u0;
        fval = objective_function_symm(u0, x_source, y_source, ...
            plus_sources, ...
            minus_sources);
    else
        [u,fval] = fminsearch(...
            @(uu) objective_function_symm(uu, x_source, y_source, ...
            plus_sources, ...
            minus_sources), ...
            u0,options);
    end
    % Save result
    res.u = u;
    res.fval = fval;
    res.minus_sources = minus_sources;
    res.plus_sources = plus_sources;
    res.x_source = x_source;
    res.y_source = y_source;
    res.seed = u0;
    res.options = options;
    results = [results res];
    if fval < best
        best = fval;
        u_best = u;
    end
end

%% Choose
% [~,index] = sortrows([results.fval].'); results = results(index); clear index
i = 1;
u = results(i).u;
minus_sources = results(i).minus_sources ;
plus_sources = results(i).plus_sources;
num_sources = minus_sources + plus_sources;

%% Plot
figure(99);
clf;
rectangle('position', [-1 -1 2 2], 'curvature', 1);
hold on;
plot(x_source, y_source, 'xb', 'MarkerSize', 24)
axis equal;

xx = []; yy = [];
for i = 1:plus_sources
    xx = [xx u(2*i-1)*cos(th0+u(2*i))];
    yy = [yy u(2*i-1)*sin(th0+u(2*i))];
    
    xx = [xx u(2*i-1)*cos(th0-u(2*i))];
    yy = [yy u(2*i-1)*sin(th0-u(2*i))];
end
plot(xx, yy, '.r', 'MarkerSize', 24)
i = plus_sources;
xx = []; yy = [];
for i = i+1:num_sources
    xx = [xx u(2*i-1)*cos(th0+u(2*i))];
    yy = [yy u(2*i-1)*sin(th0+u(2*i))];
    
    xx = [xx u(2*i-1)*cos(th0-u(2*i))];
    yy = [yy u(2*i-1)*sin(th0-u(2*i))];
end
plot(xx, yy, '.b', 'MarkerSize', 24)

box on;

%% Post-processor

% for i = 1:3
%     [th(i) r(i)] = cart2pol(u(2*i-1), u(2*i));
% end