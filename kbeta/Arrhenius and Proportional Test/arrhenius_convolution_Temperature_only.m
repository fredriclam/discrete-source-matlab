% Arrhenius problem in 1-D adiabatic domain, Green's convolution
%  Setup: four particles in [0,10] (at even x) with Arrhenius temperature
%  dependence of reaction. Tests fidelity of Green's function model in this
%  context at some fixed time.

%  Comparison against discrete Green's convolution model for Arrhenius is
%  good and independent of dt in the discrete case, for four particles.
error('Setup to use proportional, not Arrhenius!')
function u_history_discrete = arrhenius_convolution_Temperature_only(dt)
% Domain length
L = 10;
% Mesh size
N = 5000; % N grid points
dx = L/(N+1);% 
% Mesh
x = linspace(0,L,N+2)'; x = x(2:end-1);

% Time
t = 0;
% dt = 0.001;
t_max = 5;
historyDepth = ceil(t_max/dt)+1;

% Reaction term;
T_a = 1;
reaction_rate = @(T) exp(-T_a/T);

% Discrete cloud with adiabatic images

cloud = [kbParticle1Dadiabatic(2,historyDepth,L,dt) ...
    kbParticle1Dadiabatic(4,historyDepth,L,dt) ...
    kbParticle1Dadiabatic(6,historyDepth,L,dt) ...
    kbParticle1Dadiabatic(8,historyDepth,L,dt)];
% cloud = [kbParticle1Dadiabatic(5,historyDepth,L,dt)];
for i = 1:length(cloud)
    T = 1;
    cloud(i) = cloud(i).initialize(T);
end

%% Processing
% Data vector construction
u = ones(N,1);

t_vector = 0:dt:t_max;
u_history_discrete = nan(4, length(t_vector));
% u_history_discrete = nan(1, length(t_vector));
for step_number = 1:length(t_vector)
    disp(['Processing step ' num2str(step_number)])
    %% Step
    for i = 1:length(cloud)
        T = 1;
        % Compute progress variable & temperature contribution from each
        % particle j (including particle i->i itself--this one's stiff and
        % is the cause for needing to spread out the spatial dirac delta)
        for j = 1:length(cloud)
            T_contribution = cloud(j).convolveT(...
                cloud(i).x);
            T = T + T_contribution;
        end
        % Store next state of particle i
        cloud(i) = cloud(i).storeState(T);
    end
    % Update each particle state
    for i = 1:length(cloud)
        cloud(i) = cloud(i).updateState();
    end
    u_history_discrete(:,step_number) = [cloud(1).TNew ...
        cloud(2).TNew cloud(3).TNew cloud(4).TNew];
%     u_history_discrete(:,step_number) = [cloud(1).TNew];
end

%% Post-process
figure;
plot([0 2 4 6 8 10],[0; u_history_discrete(:,end); 0],'.')
% plot([0 5 10],[0; u_history_discrete(:,end); 0],'.')
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$T$','Interpreter','latex','FontSize',14)
title(['discrete $dt =' num2str(dt) '$, at time $t = ' ...
    num2str(t_vector(end)) '$'],'Interpreter','latex','FontSize',14);
set(gca,'FontSize',12,'TickLabelInterpreter','latex')

output_name = 'fig1';
try_number = 1;
while exist([output_name '.fig'])
    try_number = try_number + 1;
    output_name = ['fig' num2str(try_number)];
end
savefig([output_name '.fig']);