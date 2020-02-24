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
subfolder = 'super-discrete-AR-100-nu-3-1';
userInput = questdlg(['Platform: ' platform ' in folder ' subfolder '?']);
assert(strcmpi(userInput,'yes'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if we're in the right place so I don't spill files everywhere
assert(strcmpi(cd,'c:\users\fredy\documents\matlab\staging'));
batch_string = [];
% Get folder name
switch platform
    case 'Guillimin'
        folder_name = '/gs/project/wdr-264-aa/flam4/jobs/';
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
%% Runs %%%%%%%%%%%%%%%%%%%%%%%%%vvvvvvvvvvv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

total_instances_set = 10; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 3;
% Fixed parameters across run
geom = 'cylinder';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.01, 0.025, 0.05, 0.1, 0.15, 0.2];
tauc_vector = 0;
time_limit_matrix = 64+zeros(6,1);
nominal_dim_matrix = 2*[1.4, 1.7, 2.2, 2.9, 3.5, 4.3]';
% % Check input sizes
% assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% Order all runs
for i = 1:length(theta_ign_vector)
    for j = 1:length(tauc_vector)
        % Grab parameter
        time_limit = time_limit_matrix(i,j);
        nominal_dim = nominal_dim_matrix(i,j);
        theta_ign = theta_ign_vector(i);
        tau_c = tauc_vector(j);
        % Call core function
        batch_string = hpc_writer_core(batch_string, folder_name, ...
            platform, geom, theta_ign, tau_c, heat_loss_param, ...
            nominal_dim, total_instances, time_limit);
    end
end

total_instances_set = 10; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 3;
% Fixed parameters across run
geom = 'slab';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.01, 0.025, 0.05, 0.1, 0.15, 0.2];
tauc_vector = 0;
time_limit_matrix = 84+zeros(6,1);
nominal_dim_matrix = 2*[0.5, 0.6, 0.75, 1, 1.25, 1.6]';
% % Check input sizes
% assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% Order all runs
for i = 1:length(theta_ign_vector)
    for j = 1:length(tauc_vector)
        % Grab parameter
        time_limit = time_limit_matrix(i,j);
        nominal_dim = nominal_dim_matrix(i,j);
        theta_ign = theta_ign_vector(i);
        tau_c = tauc_vector(j);
        % Call core function
        batch_string = hpc_writer_core(batch_string, folder_name, ...
            platform, geom, theta_ign, tau_c, heat_loss_param, ...
            nominal_dim, total_instances, time_limit);
    end
end

% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 100+zeros(size(26.5:1:31.5));
% time_limit_matrix = 314+zeros(size(26.5:1:31.5));
% nominal_dim_matrix = 26.5:1:31.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 50+zeros(size(9.125:0.25:11.375));
% time_limit_matrix = 317+zeros(size(9.125:0.25:11.375));
% nominal_dim_matrix = 9.125:0.25:11.375;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% 
% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 100+zeros(size(13.25:0.5:15.75));
% time_limit_matrix = 318+zeros(size(13.25:0.5:15.75));
% nominal_dim_matrix = 13.25:0.5:15.75;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end

% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 50+zeros(size(18.5:0.5:26.5));
% time_limit_matrix = 113+zeros(size(18.5:0.5:26.5));
% nominal_dim_matrix = 18.5:0.5:26.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 100+zeros(size(28.5:1:33.5));
% time_limit_matrix = 114+zeros(size(28.5:1:33.5));
% nominal_dim_matrix = 28.5:1:33.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.1;
% tauc_vector = 100+zeros(size(14.5:1:18.5));
% time_limit_matrix = 115+zeros(size(14.5:1:18.5));
% nominal_dim_matrix = 14.5:1:18.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.1;
% tauc_vector = 150+zeros(size(18.5:1:22.5));
% time_limit_matrix = 116+zeros(size(18.5:1:22.5));
% nominal_dim_matrix = 18.5:1:22.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 50+zeros(size(9:0.5:12.5));
% time_limit_matrix = 117+zeros(size(9:0.5:12.5));
% nominal_dim_matrix = 9:0.5:12.5;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 100+zeros(size(14:0.5:17));
% time_limit_matrix = 118+zeros(size(14:0.5:17));
% nominal_dim_matrix = 14:0.5:17;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.1;
% tauc_vector = 100+zeros(size(7:0.5:9));
% time_limit_matrix = 119+zeros(size(7:0.5:9));
% nominal_dim_matrix = 7:0.5:9;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 5; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.1;
% tauc_vector = 150+zeros(size(8:0.5:11));
% time_limit_matrix = 120+zeros(size(8:0.5:11));
% nominal_dim_matrix = 8:0.5:11;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end

%% 

% total_instances_set = 20; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.1;
% tauc_vector = 10;
% time_limit_matrix = 6;
% nominal_dim_matrix = 4;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end

% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 50+zeros(size(18:2:28));
% time_limit_matrix = 120+zeros(size(18:2:28));
% nominal_dim_matrix = 18:2:28;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs - I
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% % % Order all runs - II
% % for i = 1:length(theta_ign_vector)
% %     for j = 1:length(tauc_vector)
% %         % Grab parameter
% %         time_limit = time_limit_matrix(i,j);
% %         nominal_dim = nominal_dim_matrix(i,j);
% %         theta_ign = theta_ign_vector(i);
% %         tau_c = tauc_vector(j);
% %         % Call core function
% %         batch_string = hpc_writer_core(batch_string, folder_name, ...
% %             platform, geom, theta_ign, tau_c, heat_loss_param, ...
% %             nominal_dim, total_instances, time_limit);
% %     end
% % end
% 
% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.3;
% tauc_vector = 50+zeros(size(20:4:36));
% time_limit_matrix = 120+zeros(size(20:4:36));
% nominal_dim_matrix = 20:4:36;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs - I
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.2;
% tauc_vector = 50+zeros(size(10:0.5:15));
% time_limit_matrix = 120+zeros(size(10:0.5:15));
% nominal_dim_matrix = 10:0.5:15;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end
% 
% total_instances_set = 1; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = 0.3;
% tauc_vector = 50+zeros(size(12:1:20));
% time_limit_matrix = 120+zeros(size(12:1:20));
% nominal_dim_matrix = 12:1:20;
% % % Check input sizes
% % assert(size(time_limit_matrix)==size(nominal_dim_matrix));
% % Order all runs
% for i = 1:length(theta_ign_vector)
%     for j = 1:length(tauc_vector)
%         % Grab parameter
%         time_limit = time_limit_matrix(i,j);
%         nominal_dim = nominal_dim_matrix(i,j);
%         theta_ign = theta_ign_vector(i);
%         tau_c = tauc_vector(j);
%         % Call core function
%         batch_string = hpc_writer_core(batch_string, folder_name, ...
%             platform, geom, theta_ign, tau_c, heat_loss_param, ...
%             nominal_dim, total_instances, time_limit);
%     end
% end

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

% Persistent file ID to prevent overwriting
persistent RUN_ID;
if isempty(RUN_ID)
    RUN_ID = 1;
else
    RUN_ID = RUN_ID + 1;
end

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
    num2str(1000*tau_c) '-' padded_tign '-' padded_nu '_' num2str(RUN_ID) '_'];

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