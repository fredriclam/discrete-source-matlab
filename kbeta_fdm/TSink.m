% Gaussian bump with unit integral
% Taking s -> 0 gives a delta approximation
gaussian = @(x,s) exp(-(x/s).^2) / sqrt(pi) / s; % Integrates to 1 in [-inf, inf]
gaussian_unnormalized = @(x,s) exp(-x.^2/s); % Integrates to whatever
gaussian_normalized = @(x,s) gaussian_unnormalized(x,s) ./ ...
    integral(@(x)gaussian_unnormalized(x,s),-5,5); % Integrates to 1 in [-5, 5]

% Grid points
n = 10000 + 1;
% Width of Gaussian
epsilon = 1e-5;
% Timestep (FTCS -- forward Euler with central differences)
dt = 5e-7;
assert(dt <= 0.5 * (10/(n-1))^2, 'FTCS stability condition not met.')

% Define grid
x = linspace(-5, 5, n)';
h = x(2) - x(1);
midIndex = (length(x)+1)/2;
assert(midIndex == floor(midIndex), ...
       'Number of grid points n is not odd (need middle index!)');

% Define initial condition
u = ones(size(x));

% Define negative-definite evolution operator
A = -gallery('tridiag',n) / h^2;
% Define adiabatic boundary conditions
A(1,2) = -A(1,1);
A(end,end-1) = -A(end,end);
% Define approximation of delta function
source_shape = -gaussian_normalized(x, epsilon);
% Define initial time, final time
t = 0;
tFinal = 3;

%% Run FTCS scheme and plot over time
% figure();
%
% % Define plotting parameters
% timer_last_plotted = 0; % Timer for plotting
% plot_interval = tFinal/10;    % Minimum time between plots
%
% while t < tFinal
%     u = u + dt * (A * u) + dt * u(midIndex) * source_shape;
%     t = t + dt;
%     % Plot timer
%     if timer_last_plotted > plot_interval
%         disp("Plotting at t = " + t);
%         timer_last_plotted = timer_last_plotted - plot_interval;
%         % Plot
%         plot(x,u);
%         figure(gcf);
%         hold on
%         drawnow;
%     end
%     timer_last_plotted = timer_last_plotted + dt;
% end
% % Switch focus to figure
% figure(gcf);

%% Run FTCS scheme and plot final with different spike height
epsilons_to_try = logspace(-1,2*log10(h), 7);
for i = 1:length(epsilons_to_try)
    source_shape = -gaussian_normalized(x, epsilons_to_try(i));
    t = 0;
    u = ones(size(x));
    disp("Solving with gaussian width " + epsilons_to_try(i));
    while t < tFinal
        u = u + dt * (A * u) + dt * u(midIndex) * source_shape;
        t = t + dt;
    end
    % Create plot at final time
    plot(x,u);
    hold on;
    figure(gcf);
    drawnow;
end

title('Heat equation with adiabatic boundaries at -5, 5; sink term $-u(x) \delta(x)$; $t = 3$', 'Interpreter', 'latex', 'FontSize', 11)
set(gca, 'FontSize', 12, 'TickLabelInterpreter', 'latex', 'XMinorTick', 'on', 'YMinorTick', 'on')
xlabel('$x$', 'interpreter', 'latex')
ylabel('$u$', 'interpreter', 'latex')

labels = {};
for i = 1:length(epsilons_to_try)
    labels{i} = ['$\epsilon = $' num2str(epsilons_to_try(i))];
end
legend(labels, 'Interpreter', 'latex', 'location', 'best')