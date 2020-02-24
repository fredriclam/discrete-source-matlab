% Generates HPC sub script. Be careful: this is WINDOWS/DOS format, which
% needs to be "glitched" into Linux format!!! Or else it won't submit!

% Guillimin: '/gs/project/wdr-264-aa/'
% Colosse: '/home/flam4/'
% folder_name needs / ... /
% name_str needs ... _

% Change these!
function hpc_helper_instance
% Define folder name
folder_name = '/home/flam4/jobs/';
batch_string = [];

% Parameters
ppn = 8; hrs = 36; i_low = 1; i_high = 15; name_str = 'JAJJ0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 36; i_low = 16; i_high = 30; name_str = 'JJAJ0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end
    
% Parameters
ppn = 8; hrs = 36; i_low = 31; i_high = 45; name_str = 'JJJA0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 40; i_low = 46; i_high = 60; name_str = 'JAJJ0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 40; i_low = 61; i_high = 75; name_str = 'JJAJ0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 36; i_low = 76; i_high = 90; name_str = 'JJJA0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 60; i_low = 91; i_high = 105; name_str = 'JAJJ0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 60; i_low = 106; i_high = 120; name_str = 'JJAJ0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 8; hrs = 60; i_low = 121; i_high = 135; name_str = 'JJJA0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

f = fopen('batch_script', 'w');
fprintf(f, batch_string);
fclose(f);

function hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high,...
    name_str)
for i = i_low:i_high
%     if i == 1 || i == 2
%         substr = '0';
%     else
%         substr = '';
%     end
    name = [name_str num2str(i)];
    mkdir (name);
    cd(name);
    
    string = ...
        [ ...
        '#PBS -S /bin/bash\n'...
        '#PBS -N ' name '\n'...
        '#PBS -A wdr-264-aa\n'...
        '#PBS -l nodes=1:ppn=' num2str(ppn) '\n'... %%%%%%%%%%%%%%%%%%%
        '#PBS -l walltime=' num2str(hrs) ':00:00\n'... %%%%%%%%%%%%%%%%%%
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
    
    cd ..
end