% Job writer for 3-D critical dimension scaling problem
% 
% See also hpc_job_writer_repair, hpc_job_writer.

% -Platform-    -ppn-   -walltime limit-
% Briaree       12      168     hr (1 wk)
% Colosse       8       48      hr (2 days)
% Guillimin     12/16   720     hr (30 days)
% MS2           8       120     hr (5 days)

% Root directories
% Guillimin: '/gs/project/wdr-264-aa/'
% Colosse: '/home/flam4/'
% folder_name needs / ... /
% name_str needs ... _

function hpc_job_writer_crit_dimension

% Select platform %%%%%%%%%%%%%%vvvvvvvvvvv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
platform = 'MS2';
subfolder = 'newtonian-loss5-1';
userInput = questdlg(['Platform: ' platform ' in folder ' subfolder '?']);
assert(strcmpi(userInput,'yes'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if we're in the right place so I don't spill files everywhere
assert(strcmpi(cd,'c:\users\fredy\documents\matlab\staging'));
batch_string = [];
% Get folder name
switch platform
    case 'Guillimin'
        folder_name = '/gs/project/wdr-264-aa/flam4/';
    case 'Briaree'
        folder_name = '/home/flam4/jobs/';
    case 'MS2'
        folder_name = '/home/flam4/jobs/';
    case 'Colosse'
        folder_name = '/home/flam4/jobs/';
    otherwise
        error('Unrecognized platform name! Check for typos/caps!');
end
% Add subfolder
if ~isempty(subfolder)
    folder_name = [folder_name subfolder '/'];
end
% Runs %%%%%%%%%%%%%%%%%%%%%%%%%vvvvvvvvvvv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tau_c_set = 0;
% heat_loss_param = 1;
total_instances_set = 240; %24
% 60 -> lossy; 240 -> standard

% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% tau_c = tau_c_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.15, 0.2];
% time_limit_vector = zeros(size(theta_ign_vector))+120;
% nominal_dim_vector = [7, 10];
% % Check vector sizes
% assert(length(time_limit_vector)==length(nominal_dim_vector) && ...
%     length(nominal_dim_vector)==length(theta_ign_vector));
% % Order all runs
% for i = 1:length(theta_ign_vector);
%     % Grab parameter
%     time_limit = time_limit_vector(i);
%     nominal_dim = nominal_dim_vector(i);
%     theta_ign = theta_ign_vector(i);
%     % Call core function
%     batch_string = hpc_writer_core(batch_string, folder_name, platform,...
%     geom, theta_ign, tau_c, heat_loss_param, ...
%     nominal_dim, total_instances, time_limit);
% end
% 
% 
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% tau_c = tau_c_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.2, 0.25, 0.3];
% time_limit_vector = zeros(size(theta_ign_vector))+120;
% nominal_dim_vector = [7, 10, 10];
% % Check vector sizes
% assert(length(time_limit_vector)==length(nominal_dim_vector) && ...
%     length(nominal_dim_vector)==length(theta_ign_vector));
% % Order all runs
% for i = 1:length(theta_ign_vector);
%     % Grab parameter
%     time_limit = time_limit_vector(i);
%     nominal_dim = nominal_dim_vector(i);
%     theta_ign = theta_ign_vector(i);
%     % Call core function
%     batch_string = hpc_writer_core(batch_string, folder_name, platform,...
%     geom, theta_ign, tau_c, heat_loss_param, ...
%     nominal_dim, total_instances, time_limit);
% end

heat_loss_param = 0;
% Fixed parameters across run
geom = 'slab';
total_instances = total_instances_set;
tau_c = tau_c_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.005, 0.01, 0.02, 0.03, 0.04, 0.05, ...
    0.075, 0.1];
time_limit_vector = zeros(size(theta_ign_vector))+120;
nominal_dim_vector = [0.8, 0.85, 0.9, ...
    1, 1.2, 1.8, 2.3, 2.7];
% Check vector sizes
assert(length(time_limit_vector)==length(nominal_dim_vector) && ...
    length(nominal_dim_vector)==length(theta_ign_vector));
% Order all runs
for i = 1:length(theta_ign_vector);
    % Grab parameter
    time_limit = time_limit_vector(i);
    nominal_dim = nominal_dim_vector(i);
    theta_ign = theta_ign_vector(i);
    % Call core function
    batch_string = hpc_writer_core(batch_string, folder_name, platform,...
    geom, theta_ign, tau_c, heat_loss_param, ...
    nominal_dim, total_instances, time_limit);
end

% Fixed parameters across run
geom = 'cylinder';
total_instances = total_instances_set;
tau_c = tau_c_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.005, 0.01, 0.02, 0.03, 0.04, 0.05, ...
    0.075, 0.1];
time_limit_vector = zeros(size(theta_ign_vector))+120;
nominal_dim_vector = [3.4, 3.4, 3.5, 3.5,...
    4, 4.5, 5, 6];
% Check vector sizes
assert(length(time_limit_vector)==length(nominal_dim_vector) && ...
    length(nominal_dim_vector)==length(theta_ign_vector));
% Order all runs
for i = 1:length(theta_ign_vector);
    % Grab parameter
    time_limit = time_limit_vector(i);
    nominal_dim = nominal_dim_vector(i);
    theta_ign = theta_ign_vector(i);
    % Call core function
    batch_string = hpc_writer_core(batch_string, folder_name, platform,...
    geom, theta_ign, tau_c, heat_loss_param, ...
    nominal_dim, total_instances, time_limit);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print the batch run script
f = fopen('batch_run_script', 'w');
fprintf(f, batch_string);
fclose(f);

% Core function
function batch_string_out = hpc_writer_core(...
    batch_string, folder_name, platform, ...
    geom, theta_ign, tau_c, heat_loss_param, ...
    nominal_dim, total_instances, time_limit)

% Choose executable to use
if strcmpi(geom,'cylinder')
    if tau_c == 0
        executable_name = 'FFR_cyl_zero_newton';
    else
        executable_name = 'FFR_cyl_burntime_newtonian';
    end
elseif strcmpi(geom,'slab')
    if tau_c == 0
        executable_name = 'FFR_slab_zero_newton';
    else
        executable_name = 'FFR_slab_burntime_newton';
    end
else
    error ('Geometry not recognized!');
end

% Default ppn's
switch platform
    case 'Guillimin'
        compiler_load_string = ...
            'module load icc\n';
        submission_command = 'qsub';
        ppn_default = 12;
    case 'Briaree'
        compiler_load_string = ...
            'module load intel-compilers/12.1.2.273\n';
        submission_command = 'qsub';
        ppn_default = 12;
    case 'MS2'
        compiler_load_string = ...
            ['module load intel64/15.3.187\n' ...
            'module load gcc/4.8.1\n'];
        submission_command = 'qsub';
        ppn_default = 8;
    case 'Colosse'
        compiler_load_string = ...
            'module load compilers/intel/14.0\n';
        submission_command = 'msub';
        ppn_default = 8;
    otherwise
        error('Unrecognized platform name! Check for typos/caps!');
end

% Calculate number of nodes needed
nodes_required = ceil(total_instances/ppn_default);
% Number of runs on last node
last_node_runs = mod(total_instances, ppn_default);

% Generate job name
padded_tign = num2str(theta_ign*1000);
padded_nu = num2str(heat_loss_param*1000);
while length(padded_tign) < 4
    padded_tign = ['0' padded_tign];
end
job_name_root = ['CRIT-' executable_name...
    num2str(1000*tau_c) '-' padded_tign '-' padded_nu '_'];

for i = 1:nodes_required
    job_name = [job_name_root num2str(i)];
    
    % If on the last node required
    if i == nodes_required
        if last_node_runs ~= 0
            ppn = last_node_runs;
        else
            ppn = ppn_default;
        end
    else
        ppn = ppn_default;
    end
    
    string = [...
        '#PBS -S /bin/bash\n'...
        '#PBS -N ' job_name '\n'...
        '#PBS -A wdr-264-aa\n'... Group name
        '#PBS -l nodes=1:ppn=' num2str(ppn) '\n'...
        '#PBS -l walltime=' num2str(time_limit) ':00:00\n'];
    
    % Module load line
    string = [string...
        compiler_load_string];
    % CD line
    string =  [string...
        'cd ' folder_name '\n'];
    
    % Add the run lines
    add = [];
    for j = 1:ppn
        add = [add ...
        folder_name ...
        executable_name ' <<< "' num2str(theta_ign)...
        ' ' num2str(tau_c) ...
        ' ' num2str(nominal_dim) ...
        ' ' num2str(ppn_default*(i-1)+j) '" &\n'];
    end
    add = [add 'wait'];
    string = [string add];
    
    f = fopen([job_name '.txt'], 'w');
    fprintf(f, string);
    fclose(f);
    
    % Append job submission instruction to batch job submission file
    batch_string = [batch_string, ...
        submission_command ' ' job_name '.txt\n'];
end

batch_string_out = batch_string;