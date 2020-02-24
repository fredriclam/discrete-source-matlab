% % Deletes BACKUP and eitable for every subfolder in
% folders_to_search_for = 'L*';
% folder_list = dir(folders_to_search_for);
% 
% for i = 1:length(folder_list)
%     cd(folder_list(i).name);
%     files = dir('BACK*');
%     for j = 1:length(files)
%         disp(files(j).name)
%         delete(files(j).name)
%     end
%     
%     files = dir('eitable.dat');
%     for j = 1:length(files)
%         disp(files(j).name)
%         delete(files(j).name)
%     end
%     cd ..;
% end


close all;
% Graph
% Work vector Q
clear Q
% Choose data
S = S55_trim;
Q{1} = S(1:11); % <----
Q{2} = S(12:23); % <----
Q{3} = S(24:35); % <----
Q{4} = S(36:47); % <----
Q{5} = S(48:end);

cases = 5;

% Plot
figure(57); clf;
for i = 1:cases
    y = [Q{i}.beta_naive];
    x = [Q{i}.L];
    neg = y - [Q{i}.ci_low];
    pos = [Q{i}.ci_high] - y;
    % Plot
    errorbar(x, y, neg, pos,...
        'Color', get_rainbow_colour(i,cases));
    legend({'0', '0.1', '1', '10', '100'});
    if i == 1
        hold on
    end
end
xlabel 'L'
ylabel '\beta'

% Plot
FIG_N = 58;
for i = 1:cases
    all_t = {Q{i}.t};
    all_W = {Q{i}.W};
    all_L = {Q{i}.L};
    tauc = {Q{i}.tauc}; tauc = tauc{1};
    % Stringify all_L for use as legend
    for j = 1:length(all_L)
        all_L{j} = num2str(all_L{j});
    end
    % Individual plot
    figure(FIG_N+i); clf;
    for j = 1:length(all_t)
        t = all_t{j};
        W = all_W{j};
        plot(log10(t), log10(W),...
            'color', get_rainbow_colour(j,length(all_t)));
        if j == 1; hold on; end
    end
    legend(all_L, 'location', 'best');
    title (['tauc' num2str(tauc)]);
    xlabel 'log_{10} t'
    ylabel 'log_{10} W'
    
    % All-combined plot
    figure(1000)
    for j = 1:length(all_t)
        t = all_t{j};
        W = all_W{j};
        plot(log10(t), log10(W),...
            'color', get_rainbow_colour(i,cases));
        if i == 1 && j == 1
            hold on
        end
    end
    
    
end

figure(1000);
xlabel 'log_{10} t'
ylabel 'log_{10} W'