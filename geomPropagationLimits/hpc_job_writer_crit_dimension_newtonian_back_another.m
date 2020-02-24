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
subfolder = 'speed-deficit-1';
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

total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 0;
% Fixed parameters across run
geom = 'slab';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.2];
tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
time_limit_matrix = [26, 26, 26, 26, 26, 26, 26, 26];
nominal_dim_matrix = [7., 7.5, 8, 8.5, ...
    9, 10, 11, 12];
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

total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 0;
% Fixed parameters across run
geom = 'slab';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.05];
tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
time_limit_matrix = [26, 26, 26, 26, 26, 26, 26, 26];
nominal_dim_matrix = [2.5, 2.7, 2.9, 3.1, ...
    3.1, 3.4, 3.7, 4];
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

% Expedited 0.1
total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 0;
% Fixed parameters across run
geom = 'slab';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.1];
tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
time_limit_matrix = [26, 26, 26, 26, 26, 26, 26, 26];
nominal_dim_matrix = [4.2, 4.6, 4.8, 5.2, ...
    6.3, 6.7, 7.1, 7.5];
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

total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 0;
% Fixed parameters across run
geom = 'cylinder';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.2];
tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
time_limit_matrix = [26, 26, 26, 26, 26, 26, 26, 26];
nominal_dim_matrix = [14, 15, 16, 17., ...
    15.5, 17, 18.5, 20];
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

total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
heat_loss_param = 0;
% Fixed parameters across run
geom = 'cylinder';
total_instances = total_instances_set;
% Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
theta_ign_vector = [0.05];
tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
time_limit_matrix = [26, 26, 26, 26, 26, 26, 26, 26];
nominal_dim_matrix = [5.7, 6, 6.3, 6.6, ...
    7.2, 7.7, 8.2, 8.7];
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

% CICS 1.Slab
% total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.1];
% tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
% time_limit_matrix = [50, 50, 50, 50, 50, 50, 50, 50];
% nominal_dim_matrix = [4.2, 4.6, 4.8, 5.2, ...
%     6.3, 6.7, 7.1, 7.5];
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

% CICS 1.Cylinder
% total_instances_set = 8; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.1];
% tauc_vector = [50, 50, 50, 50, 100, 100, 100, 100];
% time_limit_matrix = [50, 50, 50, 50, 50, 50, 50, 50];
% nominal_dim_matrix = [7.1, 7.6, 8.1, 8.8, ...
%     9.4, 10, 10.6, 11.2];
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














% total_instances_set = 40; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.05, 0.1, 0.2, 0.3];
% tauc_vector = [2, 3, 5, 7, 10, 20];
% time_limit_matrix = [120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120];
% nominal_dim_matrix = [0.8, 0.9, 1.1, 1.2, 1.5, 1.7;
%     1.2, 1.3, 1.8, 2, 2.2, 2.7;
%     2.7, 3.2, 4.1, 4.8, 5.3, 6;
%     4.4, 6, 8, 0, 0, 0];
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
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.01, 0.025];
% tauc_vector = [0.01, 0.05, 0.1, 0.3, 0.6, 1, 2, 3, 5, 7, 10, 20];
% time_limit_matrix = [50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 55, 60;
%     50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 60, 70;];
% nominal_dim_matrix = [0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.6, 0.7;
%     0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.45, 0.5, 0.6, 0.7, 0.8];
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
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.1];
% tauc_vector = [20];
% time_limit_matrix = [120];
% nominal_dim_matrix = [2.8];
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
% % Fixed parameters across run
% geom = 'slab';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.2];
% tauc_vector = [5, 7];
% time_limit_matrix = [120, 120];
% nominal_dim_matrix = [2.7, 3.2];
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
% total_instances_set = 60; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.01, 0.025];
% tauc_vector = [7, 10, 20];
% time_limit_matrix = [50, 60, 70;
%     55, 65, 75];
% nominal_dim_matrix = [1.5, 1.5, 1.8;
%     2, 2.3, 2.8];
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
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.2];
% tauc_vector = [5];
% time_limit_matrix = [120];
% nominal_dim_matrix = [7.7];
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
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.3];
% tauc_vector = [3, 5];
% time_limit_matrix = [120, 120];
% nominal_dim_matrix = [9.5, 11];
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

% BLOCK FOR CYL, SET 2: REDO THESE ONES WITH INIT FACTOR 1, TIMEOUT=1000
% total_instances_set = 60; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.05, 0.1, 0.2, 0.3];
% tauc_vector = [2, 3, 5, 7, 10, 20];
% time_limit_matrix = [120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120];
% nominal_dim_matrix = [2.1, 2.2, 3., 3.5, 4, 5;
%     3.3, 3.8, 4.2, 5, 6, 6.2;
%     5.6, 6.2, 6.2, 7.2, 9, 10;
%     8.5, 9, 9, 10, 12, 14];
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
% % Low theta_ign case
% total_instances_set = 60; % 60 -> newtonian-losses; 240 -> standard
% heat_loss_param = 0;
% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.01, 0.025];
% tauc_vector = [0.01, 0.05, 0.1, 0.3, 0.6, 1, 2, 3, 5];
% time_limit_matrix = [10, 10, 10, 10, 10, 10, 10, 10, 10;
%     30, 30, 30, 30, 30, 30, 30, 30, 30];
% nominal_dim_matrix = [1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.5, 1.6, 1.7;
%     1.7, 1.7, 1.7, 1.7, 1.7, 1.7, 1.7, 1.8, 2];
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


% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SLAB 1
% theta_ign_vector = [0.05, 0.1, 0.2, 0.3];
% tauc_vector = [0.01, 0.05, 0.1, 0.3, 0.6, 1, 3, 10];
% time_limit_matrix = [30, 60, 80, 120, 120, 120, 120, 120;
%     40, 70, 90, 120, 120, 120, 120, 120;
%     70, 100, 120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120, 120, 120];
% nominal_dim_matrix = [0.6, 0.6, 0.6, 0.7, 0.7, 0.7, 0.7, 0.7;
%     1, 1, 1, 1, 1, 1, 1, 1;
%     1.6, 1.6, 1.6, 1.6, 1.6, 1.7, 1.8, 1.9;
%     2.5, 2.5, 2.5, 2.5, 2.7, 3, 3.3, 3.5];
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CYL 1
% theta_ign_vector = [0.05, 0.1, 0.2, 0.3];
% tauc_vector = [0.01, 0.05, 0.1, 0.3, 0.6, 1, 3, 10];
% time_limit_matrix = [30, 60, 80, 120, 120, 120, 120, 120;
%     40, 70, 90, 120, 120, 120, 120, 120;
%     70, 100, 120, 120, 120, 120, 120, 120;
%     120, 120, 120, 120, 120, 120, 120, 120];
% nominal_dim_matrix = [2.9, 2.9, 2.9, 2.9, 2.9, 2.9, 2.9, 2.9;
%     2.9, 2.9, 2.9, 2.9, 2.9, 2.9, 2.9, 2.9;
%     4.2, 4.2, 4.2, 4.2, 4.2, 4.4, 4.5, 5.2;
%     6.3, 6.3, 6.4, 6.6, 6.8, 7.2, 7.7, 8.2];




% % Fixed parameters across run
% geom = 'cylinder';
% total_instances = total_instances_set;
% tau_c = tau_c_set;
% % Run information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% theta_ign_vector = [0.005, 0.01, 0.02, 0.03, 0.04, 0.05, ...
%     0.075, 0.1];
% time_limit_vector = zeros(size(theta_ign_vector))+120;
% nominal_dim_vector = [3.4, 3.4, 3.5, 3.5,...
%     4, 4.5, 5, 6];
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