% Sift all MISC*.dat files for the average ignition times of the n-th
% particle

clear all; clc;
SD = dir;
ALL = {};
for i = 1:length(SD)
    if SD(i).isdir && ~strcmp(SD(i).name,'.') && ~strcmp(SD(i).name,'..')
        % Jump in folder
        cd (SD(i).name)
        
        sum = zeros(36000,1);
        D = dir('MISC*.dat');
        for j = 1:length(D)
            file_name = D(j).name;
            data = importdata(file_name);
            ignition_times = data(:,1);
            sum = sum + ignition_times;
        end
        average_ignition_times = sum ./ length(D);
        [t, W] = extract_average;
        
        N = [];
        % Using t as 249x1:
        for j = 1:length(t)
            N(j) = t_to_num_particles(average_ignition_times, t(j));
        end
        
        if isrow(W)
            W = W';
        end
        if isrow(N)
            N = N';
        end
        
        ALL{i} = [N, W];
        
        % Jump out of folder
        cd ..
        disp(i)
    end
end