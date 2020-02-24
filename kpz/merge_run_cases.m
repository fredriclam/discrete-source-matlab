% Clean up results hot off the supercomputers!
% Merges folders from different jobs into single folders using the same
% test parameters (TIGN, TAUC).

% Remove '.' and '..'
D = dir;
i = 1;
while i <= length(D)
    if strcmp(D(i).name, '.') || strcmp(D(i).name,'..') || ~D(i).isdir
        D(i) = [];
    else
        i = i + 1;
    end
end

radical_list = {};

n = 1;
for i = 1:length(D)
    % Extract string up to and excluding the underscore
    str = D(i).name(1:(regexp(D(i).name,'_')-1));
    if ~ismember(str, radical_list)
        radical_list{n} = str;
        n = n + 1;
    end
end

% For each radical
for j = 1:length(radical_list)
    % Get the radical to merge folders to
    match_name = radical_list{j};
    % Make sure the merging folder doesn't exist
    assert(~exist(match_name,'dir')); 
    % Make the merging folder
    mkdir(match_name);
    % For each raw source directory
    for i = 1:length(D)
        % If matches current name (filter out)
        if ~isempty(regexp(D(i).name,match_name))
           % Grab subdirectory file list
           file_list = dir(D(i).name);
           % Filter out folders (and '.', '..')
           k = 1;
           while k <= length(file_list)
               if file_list(k).isdir
                   file_list(k) = [];
               else
                   k = k + 1;
               end
           end
           % Move every file by case
           for k = 1:length(file_list)
               file_name = file_list(k).name;
               % Leave these behind
               if strcmp(file_name,'FFR') || strcmp(file_name,'eitable.dat')
                   target_name = [];
               % Rename config files
               elseif strcmp (file_name ,'config.dat')
                   target_name = ['config_', D(i).name, '.dat'];
               % Copy these as-are
               else
                   target_name = file_name;
               end
               % Skip ignored case, but otherwise move to current directory
               if ~isempty(target_name)
                   movefile([D(i).name '/' file_name],...
                       [match_name '/' target_name]);
               end
           end
        end
    end
end