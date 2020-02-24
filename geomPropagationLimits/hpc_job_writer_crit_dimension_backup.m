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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if we're in the right place so I don't spill files everywhere
assert(strcmpi(cd,'c:\users\fredric\documents\matlab\Genesis'));
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

% Runs %%%%%%%%%%%%%%%%%%%%%%%%%vvvvvvvvvvv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

geom = 'cylinder'; theta_ign = 0.1; tau_c = 0.2;
nominal_dim = 3; total_instances = 24; time_limit = 12;
% Call core function
batch_string = hpc_writer_core(batch_string, folder_name, platform,...
geom, theta_ign, tau_c, nominal_dim, total_instances, time_limit);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print the batch run script
f = fopen('batch_run_script', 'w');
fprintf(f, batch_string);
fclose(f);

% Core function
function batch_string_out = hpc_writer_core(...
    batch_string, folder_name, platform, ...
    geom, theta_ign, tau_c, nominal_dim, total_instances, time_limit)

% folder_name, ppn, hrs, index_range,...
%     name_str, platform, batch_string)

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
while length(padded_tign) < 4
    padded_tign = ['0' padded_tign];
end
job_name_root = ['CRIT-' num2str(1000*tau_c) '-' padded_tign '_'];

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
        geom ' <<< "' num2str(theta_ign)...
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