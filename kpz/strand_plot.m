% Builds a strand plot out of data in all current subdirectories. The
% so-called strand plot is the superimposed collection of all ln(W)-ln(t)
% plots. Ignores all folders containing the character '@'.
%
% See also ensemble_convergence_spectrum, ensemble_conv_everything

function strand_plot()
% All subdirectories
D = dir;
j = 1;
for i = 1:length(D)
    if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..') ...
        && isempty(regexp(D(i).name,'@', 'once'))
        % Jump in folder
        cd (D(i).name)
        
        % Code
        if length(dir) > 2
            [x, y] = extract_average();
            all_data{j} = [x, y];
            labels{j} = D(i).name;
            j = j + 1;
        end
        
        % Jump out of folder
        cd ..
    end
end

max = Inf;
figure(7); hold on;
for j = 1:length(all_data)
    V = all_data{j};
    x = V(:,1);
    y = V(:,2);
    logx = log(x); % ln(x)
    logy = log(y); 
    plot(logx, logy, 'Color', get_rainbow_colour(j,length(all_data)));
end
legend(labels, 'Location', 'EastOutside');
adjplot('ln \it{t}', 'ln \it{W}');