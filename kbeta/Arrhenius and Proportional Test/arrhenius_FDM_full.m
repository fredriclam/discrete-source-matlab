% Arrhenius problem in 1-D adiabatic domain
%  Setup: four particles in [0,10] (at even x) with Arrhenius
%  WIP

% Domain length
L = 10;
% Mesh size
N = 100; % N grid points
dx = L/(N+1);% 
boxcar_width = 1;
% Mesh
x = linspace(0,L,N+2)'; x = x(2:end-1);

% Time
t = 0;
dt = 0.01;
t_max = 10;

% Reaction term;
T_a = 1;
reaction_rate = @(T,C) C .* exp(-T_a/T);

% Cloud
particle = @(x,T,C,loc) smoothBoxcar(x,loc,boxcar_width) / ...
    boxcar_width .* interp1(x,T,C,loc);
reaction_term = @(x,T,C) particle(x,T,C,2) + ...
    particle(x,T,C,4) + ...
    particle(x,T,C,6) + ...
    particle(x,T,C,8);

%% Numerics
% Diffusion matrix (nabla^2)
A = gallery('tridiag',N,1,-2,1);
% Neumann adiabatic boundaries
A(1,2) = 2;
A(end,end-1) = 2;
A = 1/dx^2 * A;

% Preprocessing LHS and RHS matrices
LHS = speye(N) - 0.5*dt*A;
RHS = speye(N) + 0.5*dt*A;

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
plot(x,u_history(:,end))