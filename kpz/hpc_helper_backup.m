% Generates HPC sub script. Be careful: this is WINDOWS/DOS format, which
% needs to be "glitched" into Linux format!!! Or else it won't submit!

% Guillimin: '/gs/project/wdr-264-aa/'
% Colosse: '/home/flam4/'
% folder_name needs / ... /
% name_str needs ... _

% Change these!
folder_name = '/gs/project/wdr-264-aa/'; 
ppn = 16;
hrs = 60;
i_low = 41;
i_high = 45;
name_str = 'JJJA0400_';

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
    cd ..
end
% save([name '.txt'], 'string', '-ascii');

% for i = 1:8
%     if i == 1 || i == 2
%         substr = '0';
%     else
%         substr = '';
%     end
%     name = ['T0' substr num2str(50*i-25)];
%     mkdir (name)
%     
%     if i == 1
%         substr = '0';
%     else
%         substr = '';
%     end
%     name = ['T0' substr num2str(50*i)];
%     mkdir (name)
% end