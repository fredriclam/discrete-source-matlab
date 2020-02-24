% k-beta cloud model run (3D uniform grid of particles)
%  Perform a run of the k-beta cloud for a three-dimensional grid of
%  particles. Outputs the speed measured on the last 70% of particles.
%  Exploits symmetry of the grid of particles for speed. Performs discrete
%  convolution by simple trapezoidal rule + open Newton-Cotes. ODE
%  integration done using Forward Euler.
% 
% Input: concentration_g_L (concentration in g/L, e.g. 0.2 g/L)
% 
% Dated:
%  Aug. 18, 2018
% Dependencies:
%  kbParticle_alpha.m
% 
% Version Features:
%  Dimensional equations:
%  -Bulk gas energy equation
%  -Bulk gas oxidizer concentration equation
%  -Particle mass equation
%  -Particle energy equation
%  -Reaction rate specified by Arrhenius rate
%
%  Variables:
%  -N_particles     Number of particles (N)
%  -m_p     Particle mass (N discrete variables) [kg]
%  -T_p     Particle temperature (N discrete variables) [K}
%  -T_g     Bulk gas temperature (Continuous variable) [K]
%  -C_g     Bulk gas oxidizer concentration (Continuous variable) [kg/m^3]
% 
%  Fudge parameters:
%  -h_p     Convective heat transfer coefficient [W/m^2-K]
%  -kappa   Pre-exponential fudge factor [m/s]
%  -T_a     Activation temperature [K]
%
%  Other parameters:
%  -A_p_0               Initial particle area [m^2] OR m_p_0 Initial particle mass [kg]
%  -beta_p              Mass transfer coefficient, = D/r_p under k-beta assumptions [m^2/s]
%  -concentration_g_L   Concentration of oxidizer [g/L]
%
%
%  Constants:
%  -c_s         Heat capacity of solid [J/kg-K solid]
%  -q           Heating value of solid [J/kg solid]
%  -c_g         Bulk gas heat capacity (constant) [K/kg-K]
%  -rho_g       Bulk gas density (assumed constant; no gas motion) [kg/m^3]
%  -lambda_g    Gas conductivity (constant) [W/m-K]
%  -D           Oxidizer mass diffusivity (constant) [m^2/s]
% 
%  Equations: see documentation.
% 
%  To modify parameters, see the associated particle class (kbParticle_*.m)
% 
%  Uses explicit forward Euler integration

function flameSpeed = kbParticle_run(concentration_g_L)

%% PDE conditions
% For ambient T and C, one can instead use an extra term that evolves the
% initial conditions using a convolution against Green's functions (if the
% initial condition has compact support, this can be done analytically).

% Background ambient values of C_g, T_g
C_g_0 = 0.27; % From Soo paper
T_g_0 = 300;
% Initial temperature of particles T_p
T_p_0 = 300;
% Initial temperature of particles artificially increased for initiation
T_p_boosted = 2000;
% Initial particle radius [m], on order of micrometers
r_p_0 = 15e-6;

%% Cloud
% Number of particles
N_particles = 31;
% Domain: unbounded (i.e., BCs at infinity)

% Distance between particles in uniform grid:
% Option 1/3: specify particle separation manually
particleSeparation = 0.120e-3; % [m]

% Option 2/3: compute from stoichiometry and equivalence ratio
% Suggest particle separation (near stoichiometry)
nu = 3/4; % Coefficient of O2 in reaction divided by coefficient of Al at stoich
MWMW = 1; % Molecular weight ratio (MW_g/MW_s)
rho_s = 2700.0; % Solid aluminum density
phi = 1; % Phi
% Volume of air around each particle
volCell = 4/3*pi*nu*MWMW*r_p_0^3*rho_s/C_g_0/phi;
% Particle separation calculation
particleSeparation = volCell^(1/3);

% Option 3/3: compute from fuel concentration in g/L
% Assumes concentration_g_L is passed in function
% Compute mass in kg, convert
mass_kg = r_p_0^3*pi*4/3*2700;
mass_g = mass_kg * 1000;
vol_L = mass_g/concentration_g_L;
vol_m3 = vol_L/1e3;
particleSeparation = vol_m3^(1/3);

% Number of images for periodic BCs manually coded in particle class

%% Numerical
% Integration parameters
dt = 20*1e-4; % Try 1e-4 to 1e-3
t = 0;
tFinal = 2.0;

% % % % % Ignore
% % % % % Plotting grid parameters
% % % % NxGrid = 16;
% % % % NyGrid = 16;
% % % % 
% % % % % Plot with approximate t (const) between plotting frames
% % % % t_between_frames_nominal = 0.05; % Approximate
% % % % PLOT_EVERY = ceil(t_between_frames_nominal/dt);
% % % % t_between_frames_actual = PLOT_EVERY*dt;

%% Generate cloud
% Allocate space to record full T_p, C_g, etc. history with one extra slot
historyDepth = ceil(tFinal/dt)+1; 

% Distribute particles along x-axis (images are virtual)
for i = 1:N_particles
    particles(i) = kbParticle_alpha([particleSeparation*(i),0,0],...
        r_p_0,3,historyDepth,dt,particleSeparation);
    % Ignite first particle with boosted temperature
    if i < 2
        particles(i) = particles(i).initialize(C_g_0, T_p_boosted, T_g_0);
    else
        particles(i) = particles(i).initialize(C_g_0, T_p_0, T_g_0);
    end
end

%% Run loop
cyclesCompleted = 0;
while t <= tFinal
    % Console log
    disp(['t = ' num2str(t) ' of ' num2str(tFinal)]);
    
    % Step 1: for each particle, compute physics coefficients
    for i = 1:N_particles
        particles(i) = particles(i).computePhysicsCoefficients();
    end
    % Step 2: for each particle, compute diffusion effects
    for i = 1:N_particles
        % Reset to background before contributions of particles
        C_g = C_g_0;
        T_g = T_g_0;
        % Compute progress variable & temperature contribution from each
        % particle j (including particle i->i itself--this one's stiff)
        for j = 1:N_particles
            C_g = C_g - particles(j).propagateC(...
                particles(i));
            T_g = T_g + particles(j).propagateT(...
                particles(i));
        end
        % Store state of particle i
        particles(i) = particles(i).storeState(C_g,T_g);
    end
    % Step 3: for each particle, step ODE for particle properties
    for i = 1:N_particles
        particles(i) = particles(i).timeStepParticleProperties();
    end
    % Update each particle state history (save current variables to
    % history)
    for i = 1:N_particles
        particles(i) = particles(i).updateHistory();
    end
    % Step
    t = t + dt;
    cyclesCompleted = cyclesCompleted + 1;
end

%% Post processing
% Find temperature peaks (approx. the time of ignition)
temperaturePeakIndices = nan(1,length(particles));
peakTemperatures = nan(1,length(particles));
for i = 1:length(particles)
    [peakAmp, peakLoc] = max(particles(i).TpHistory);
    peakTemperatures(i) = peakAmp;
    temperaturePeakIndices(i) = peakLoc;
end

% Vector of t values corresponding to data
tVector = 0:dt:tFinal; 
if length(tVector) < length(particles(1).TpHistory)
    tVector = 0:dt:tFinal+dt;
end

%% Try speed measurement
% Slope measurement on x = x(t)
xPosArrayFull = nan(size(particles));

% Grab all particle x-positions
for i = 1:length(particles)
    xPosArrayFull(i) = particles(i).position(1);
end
% Grab peak temperatures
temperaturePeakTimesFull = ...
    tVector(temperaturePeakIndices);

% Take latter 70% of data for slope measurement
temperaturePeakTimes = ...
    temperaturePeakTimesFull(floor(0.3*length(xPosArrayFull)):end);
xPosArray = xPosArrayFull(floor(0.3*length(xPosArrayFull)):end);

% Poly fit for flame speed
[poly, ~] = polyfit(temperaturePeakTimes,xPosArray,1);
flameSpeed = poly(1);

%% Plotting
figure(301); clf;

subplot(2,4,1);
for i = 1:N_particles
    plot(tVector,particles(i).TpHistory, 'Color', get_rainbow_colour(i,N_particles));
    if i == 1
        hold on
    end
end
title 'T_p'
xlabel 't [s]'
ylabel 'T_p [K]'

subplot(2,4,2);
for i = 1:N_particles
    plot(tVector,particles(i).TgHistory, 'Color', get_rainbow_colour(i,N_particles));
    if i == 1
        hold on
    end
end
title 'T_g'
xlabel 't [s]'
ylabel 'T_g [K]'

subplot(2,4,3);
for i = 1:N_particles
    plot(tVector,particles(i).CgHistory, 'Color', get_rainbow_colour(i,N_particles));
    if i == 1
        hold on
    end
end
title 'C_g'
xlabel 't [s]'
ylabel 'C_g [kg/m^3 oxidizer]'

subplot(2,4,4);
for i = 1:N_particles
    plot(tVector,particles(i).rpHistory, 'Color', get_rainbow_colour(i,N_particles));
    if i == 1
        hold on
    end
end
title 'Particle radius'
xlabel 't [s]'
ylabel 'r_p [m]'

subplot(2,4,5);
plot(tVector,4/3*pi*particles(1).rpHistory.^3*particles(1).rho_s.*...
    (particles(1).c_s*particles(1).TpHistory + particles(1).q), 'b');
title 'Internal + chemical energy of 1st, 11th and last particles'
hold on;
plot(tVector,4/3*pi*particles(end).rpHistory.^3*particles(end).rho_s.*...
    (particles(end).c_s*particles(end).TpHistory + particles(end).q), 'k');
plot(tVector,4/3*pi*particles(11).rpHistory.^3*particles(11).rho_s.*...
    (particles(11).c_s*particles(11).TpHistory + particles(11).q), 'k');
plot(tVector,4/3*pi*particles(end).rpHistory.^3*particles(end).rho_s.*...
    (particles(end).c_s*particles(end).TpHistory + particles(end).q), 'k');
xlabel 't [s]'
ylabel 'U [J]'

subplot(2,4,6);
plot(xPosArrayFull, temperaturePeakTimesFull,'.')
title 'x-t'
xlabel 'x [m]'
ylabel 't_{peak-temperature} [s]'

subplot(2,4,7);
plot(xPosArrayFull, peakTemperatures,'.')
title 'Peak temperatures'
xlabel 'x [m]'
ylabel 'T_{peak} [K]'

%% Find new output path and save fig (.fig) and data (.mat) to it
i = 1;
newFileName = ['kb_output' num2str(i)];
while exist([newFileName '.mat']) || exist([newFileName '.fig'])
    i = i + 1;
    newFileName = ['kb_output' num2str(i)];
end
savefig(newFileName);
save(newFileName);

%% Log speed to console
disp(['Run complete. Flame speed: ' num2str(flameSpeed*100) ' cm/s']);