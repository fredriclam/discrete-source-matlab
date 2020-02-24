%% Standard
% At fixed D and density, length
particle_diameter = 1;
cylinder_length = 10;
slab_width = 10;
particle_density = 1;

% Run parameters
NUM_RUNS = 100;
NUM_DIMENSION_TESTS = 50;
CYL_DIMENSION_MIN = 2;
CYL_DIMENSION_MAX = 7;
SLAB_DIMENSION_MIN = .5;
SLAB_DIMENSION_MAX = 4.5;

% Set up runs and go
diameter_vector = linspace(CYL_DIMENSION_MIN,CYL_DIMENSION_MAX,...
    NUM_DIMENSION_TESTS);
cylinder_success_vector = zeros(size(diameter_vector));
for i = 1:length(diameter_vector)
    % Cylinder case
    diameter = diameter_vector(i);
    % Perform simulation ensemble
    for j = 1:NUM_RUNS
        [cylinder_success, cylinder_time_of_travel] = ...
            swiss_cheese_run(particle_diameter,...
            diameter,...
            cylinder_length,...
            particle_density);
        cylinder_success_vector(i) = cylinder_success_vector(i) + ...
            cylinder_success;
    end
end
% Calculate success percentage
cylinder_success_vector = cylinder_success_vector / NUM_RUNS;
% Generate plot
plot(diameter_vector, cylinder_success_vector)
hold on;

% Set up runs and go
thickness_vector = linspace(SLAB_DIMENSION_MIN,SLAB_DIMENSION_MAX,...
    NUM_DIMENSION_TESTS);
slab_success_vector = zeros(size(thickness_vector));
for i = 1:length(thickness_vector)
    % Slab case
    thickness = thickness_vector(i);
    % Perform simulation ensemble
    for j = 1:NUM_RUNS
        [slab_success, slab_time_of_travel] = ...
            swiss_cheese_run_slab(particle_diameter,...
            thickness,...
            slab_width,...
            slab_width,...
            particle_density);
        slab_success_vector(i) = slab_success_vector(i) + ...
            slab_success;
    end
end
% Calculate success percentage
slab_success_vector = slab_success_vector / NUM_RUNS;
% Generate plot
plot(thickness_vector, slab_success_vector)


critical_number_density = -log(1-0.29) * 6/pi;


%% Check at 0.7+
% At fixed D and density, length
particle_diameter = 1;
cylinder_length = 10;
slab_width = 10;
particle_density = 0.6;

% Run parameters
NUM_RUNS = 10;
NUM_DIMENSION_TESTS = 20;
CYL_DIMENSION_MIN = 2;
CYL_DIMENSION_MAX = 7;
SLAB_DIMENSION_MIN = .5;
SLAB_DIMENSION_MAX = 4.5;

% Set up runs and go
diameter_vector = linspace(CYL_DIMENSION_MIN,CYL_DIMENSION_MAX,...
    NUM_DIMENSION_TESTS);
cylinder_success_vector = zeros(size(diameter_vector));
for i = 1:length(diameter_vector)
    % Cylinder case
    diameter = diameter_vector(i);
    % Perform simulation ensemble
    for j = 1:NUM_RUNS
        [cylinder_success, cylinder_time_of_travel] = ...
            swiss_cheese_run(particle_diameter,...
            diameter,...
            cylinder_length,...
            particle_density);
        cylinder_success_vector(i) = cylinder_success_vector(i) + ...
            cylinder_success;
    end
end
% Calculate success percentage
cylinder_success_vector = cylinder_success_vector / NUM_RUNS;
% Generate plot
plot(diameter_vector, cylinder_success_vector)
hold on;

% Set up runs and go
thickness_vector = linspace(SLAB_DIMENSION_MIN,SLAB_DIMENSION_MAX,...
    NUM_DIMENSION_TESTS);
slab_success_vector = zeros(size(thickness_vector));
for i = 1:length(thickness_vector)
    % Slab case
    thickness = thickness_vector(i);
    % Perform simulation ensemble
    for j = 1:NUM_RUNS
        [slab_success, slab_time_of_travel] = ...
            swiss_cheese_run_slab(particle_diameter,...
            thickness,...
            slab_width,...
            slab_width,...
            particle_density);
        slab_success_vector(i) = slab_success_vector(i) + ...
            slab_success;
    end
end
% Calculate success percentage
slab_success_vector = slab_success_vector / NUM_RUNS;
% Generate plot
plot(thickness_vector, slab_success_vector)