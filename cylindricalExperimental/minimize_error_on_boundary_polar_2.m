% Script to minimize error on boundary (L2 average on r = 1, averaged on t)
%   Monte carlo + MATLAB's simplex optimization

% Source position
x_source = 0.3;
y_source = 0.65;
results = [];
% t = 1/6;

% u0 = [1.1, 0, -1.1, 0, 1.1, 0, 1.1, 0, 1.1, 0, 1.1, 0, 1.1, 0, ...
%     1.1, 0, 1.1, 0];
% u0 = 2*rand(1,16);

% Best seed -> 1e-6 at t = 0.1, x 0.3, y 0.65
% u0 = [];
% R = 1.5;
% % Circle distributor
% num_sources = 16;
% for i = 1:num_sources
%     u0 = [u0 R*cos(i*pi/4) R*sin(i*pi/4)];
% end


% Sources
plus_sources = 0;
minus_sources =  6;
num_sources = plus_sources + minus_sources;

% Spiral distributor
best = 9999;
while best > 1e-7
    % Shake the box
    u0 = [];
    minus_sources = randi([3 8],1);
    num_sources = plus_sources + minus_sources;
    
    for i = 1:num_sources
        rr = 1 + i*rand(1);
        th = 2*pi*rand(1);
        u0 = [u0 rr*cos(th) rr*sin(th)];
    end

    % options = optimset('Display','iter','PlotFcns',@optimplotfval);
    options = optimset('Display','iter',...
        'PlotFcns',@optimplotfval,...
        'MaxFunEvals', 750, ...
        'MaxIter', 500, ...
        'TolX', 1e-4, ...
        'TolFun', 1e-4 ...
        );
    [u,fval] = fminsearch(...
        @(uu) objective_function(uu, x_source, y_source, plus_sources, ...
        minus_sources), ...
        u0,options);
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

%% Plot
figure(99);
clf;
rectangle('position', [-1 -1 2 2], 'curvature', 1);
hold on;
plot(x_source, y_source, 'xb', 'MarkerSize', 24)
axis equal;

xx = []; yy = [];
for i = 1:plus_sources
    xx = [xx u(2*i-1)]; 
    yy = [yy u(2*i)];
end
plot(xx, yy, '.r', 'MarkerSize', 24)
i = plus_sources;
xx = []; yy = [];
for i = i+1:minus_sources+plus_sources
    xx = [xx u(2*i-1)]; 
    yy = [yy u(2*i)];
end
plot(xx, yy, '.b', 'MarkerSize', 24)

box on;

%% Post-processor

for i = 1:3
    [th(i) r(i)] = cart2pol(u(2*i-1), u(2*i));
end