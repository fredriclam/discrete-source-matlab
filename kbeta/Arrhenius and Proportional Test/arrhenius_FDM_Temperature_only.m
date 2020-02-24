% Arrhenius problem in 1-D adiabatic domain, finite difference
%  Setup: four particles in [0,10] (at even x) with Arrhenius temperature
%  dependence of reaction. Tests fidelity of Green's function model in this
%  context at some fixed time.
%  
%  Comparison against discrete Green's convolution model for Arrhenius is
%  good and independent of dt in the discrete case, for four particles.
error('Setup to use proportional, not Arrhenius!')
% Domain length
L = 10;
% Mesh size
N = 20000; % N grid points
dx = L/(N+1);% 
boxcar_width = 0.0001;
% Mesh
x = linspace(0,L,N+2)'; x = x(2:end-1);

% Time
t = 0;
dt = 0.0005;
t_max = 5;

% Reaction term;
T_a = 1;
reaction_rate = @(T) T;%exp(-T_a/T);

% Cloud
particle = @(x,T,loc) smoothBoxcar(x,loc,boxcar_width) / boxcar_width ...
    .* reaction_rate(interp1(x,T,loc));
reaction_term = @(x,T) particle(x,T,2) + ...
    particle(x,T,4) + ...
    particle(x,T,6) + ...
    particle(x,T,8);
% reaction_term = @(x,T) particle(x,T,5);

%% Numerics
% Diffusion matrix (nabla^2)
A = gallery('tridiag',N,1,-2,1);
% Neumann adiabatic boundaries
A(1,2) = 2;
A(end,end-1) = 2;
A = 1/dx^2 * A;

% Preprocessing LHS and RHS matrices
LHS = speye(N) - 2*0.5*dt*A;
RHS = speye(N) + 0.*dt*A;

%% Processing
% Data vector construction
u = ones(N,1);

t_vector = 0:dt:t_max;
u_history = nan(length(u), length(t_vector));
for step_number = 1:length(t_vector)
    disp(['Processing step ' num2str(step_number)])
    %% Step
    u = LHS \ (reaction_term(x,u)*dt + RHS*u);
    u_history(:,step_number) = u;
end

%% Post-process
figure;
plot(x,u_history(:,end))
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$T$','Interpreter','latex','FontSize',14)
title(['boxcar width $=' num2str(boxcar_width) '$, at time $t = ' ...
    num2str(t_vector(end)) '$'],'Interpreter','latex','FontSize',14);
set(gca,'FontSize',12,'TickLabelInterpreter','latex')

output_name = 'fig1';
try_number = 1;
while exist([output_name '.fig'])
    try_number = try_number + 1;
    output_name = ['fig' num2str(try_number)];
end
savefig([output_name '.fig']);