% Generates HPC sub script. Be careful: this is WINDOWS/DOS format, which
% needs to be "glitched" into Linux format!!! Or else it won't submit!

% Guillimin: '/gs/project/wdr-264-aa/'
% Colosse: '/home/flam4/'
% folder_name needs / ... /
% name_str needs ... _

% Change these!
function hpc_helper_guillimin
assert(strcmp(cd, 'C:\Users\Fredric\Documents\MATLAB\genesis'));
% Define folder name
folder_name = '/gs/project/wdr-264-aa/';
batch_string = [];

% Parameters
ppn = 12; hrs = 36; i_low = 1; i_high = 5; name_str = 'JAJJ0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 12; hrs = 36; i_low = 6; i_high = 10; name_str = 'JJAJ0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end
    
% Parameters
ppn = 12; hrs = 36; i_low = 11; i_high = 15; name_str = 'JJJA0025_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 12; hrs = 40; i_low = 16; i_high = 20; name_str = 'JAJJ0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 12; hrs = 40; i_low = 21; i_high = 25; name_str = 'JJAJ0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 12; hrs = 36; i_low = 26; i_high = 30; name_str = 'JJJA0200_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 16; hrs = 60; i_low = 31; i_high = 35; name_str = 'JAJJ0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 16; hrs = 60; i_low = 36; i_high = 40; name_str = 'JJAJ0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Parameters
ppn = 16; hrs = 60; i_low = 41; i_high = 45; name_str = 'JJJA0400_';
% Call core function
hpc_helper_colosse_core(folder_name, ppn, hrs, i_low, i_high, name_str);
for i = i_low:i_high
    batch_string = [batch_string, ...
        'cd ' name_str num2str(i) '\n' ...
        'qsub ' name_str num2str(i) '.txt\n' ...
        'cd ..\n'];
end

% Write batch script
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
        'module load icc\n'
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