% Generates HPC submission bundle. Generates 0-byte files inside each
% folder to be replaced using:
% 
%       echo ./blahblah*/FFR | xargs -n 1 cp FFR
%       echo ./blahblah*/FFR | xargs -n 1 chmod u=rwx FFR
%       echo ./blahblah*/eitable.dat | xargs -n 1 cp eitable.dat
% 
% where FFR is my program name. In this version, each instruction sets up
% an ensemble of runs on one server, for one set of parameters.
%
% And to apply configurations to a set of folders, change the config.dat
% file and then run:
%       echo ./blahblahspecific*/config.dat | xargs -n 1 cp config.dat
% Finally, set permission -u wrx and execute batch_run_script
% 
% Specify the platform below and set up the job parameters!
% 
% See also hpc_job_writer_repair.

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

function hpc_job_writer

% Select platform %%%%%%%%%%%%%%vvvvvvvvvvv%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
platform = 'Guillimin';
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

ppn = 12; hrs = 240; index_range = 1:10; name_str = 'L600-100-0200_';
% Call core function
batch_string = hpc_writer_core(folder_name, ppn, hrs, index_range,...
    name_str, platform, batch_string);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%^^^^^^^^^^^%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Print the batch run script
f = fopen('batch_run_script', 'w');
fprintf(f, batch_string);
fclose(f);

% Core function
function batch_string_out = hpc_writer_core(folder_name, ppn, hrs, index_range,...
    name_str, platform, batch_string)
for i = index_range
    name = [name_str num2str(i)];
    mkdir (name);
    cd(name);
    
    string = ...
        [ ...
        '#PBS -S /bin/bash\n'...
        '#PBS -N ' name '\n'...
        '#PBS -A wdr-264-aa\n'...
        '#PBS -l nodes=1:ppn=' num2str(ppn) '\n'... %%%%%%%%%%%%%%%%%%%
        '#PBS -l walltime=' num2str(hrs) ':00:00\n'];
    
    % Module load line
    switch platform
        case 'Guillimin'
            string = [ string ...
                'module load icc\n'];
            submission_command = 'qsub';
        case 'Briaree'
            string = [ string ...
                'module load intel-compilers/12.1.2.273\n'];
            submission_command = 'qsub';
        case 'MS2'
            string = [ string ...
                'module load intel64/15.3.187\n' ...
                'module load gcc/4.8.1\n'];
            submission_command = 'qsub';
        case 'Colosse'
            string = [ string ...
                'module load compilers/intel/14.0\n'];
            submission_command = 'msub';
        otherwise
            error('Unrecognized platform name! Check for typos/caps!');
    end

    % CD line
    string =  [ string...
        'cd ' folder_name name '\n'];

    % following dysfunctional version: thanks, mcgill!
%         [ ...
%         '#!/bin/bash\n'...
%         '#$ -l h_rt=' num2str(hrs) '\n'...
%         '#$ -pe default ' num2str(ppn) '\n'...
%         '#$ -P wdr-264-aa\n'...
%         'cd ' folder_name name '\n'];
    
    add = [];
    for j = 1:ppn
        add = [add...
        folder_name name '/FFR <<< "1 '  num2str(ppn*(i-1)+j) '" &\n'];
        
    end
    add = [add 'wait'];
    string = [string add];
    
    f = fopen([name '.txt'], 'w');
    fprintf(f, string);
    fclose(f);
    
    % Generate ghost files for mass replacement
    f = fopen('config.dat', 'w'); fclose(f);
    f = fopen('FFR', 'w'); fclose(f);
    f = fopen('eitable.dat', 'w'); fclose(f);
    
    % Append job submission instruction to batch job submission file
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        submission_command ' ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
    
    cd ..
end

batch_string_out = batch_string;