% This script calls ensemble_convergence_spectrum on every subfolder in the
% current directory.
% 
% See also: strand_plot, ensemble_convergence_spectrum

if strcmp(cd, 'c:\users\fredric\desktop') || ...
    strcmp(cd, 'c:\users\fredric\documents\matlab')
    error('You''re on your desktop or in MATLAB!!')
end

% Save strand_plot
% strand_plot();
% savefig('lnW_lnt.fig');

D = dir;
for i = 1:length(D)
    if D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..') ...
        && isempty(regexp(D(i).name,'@', 'once'))
        % Jump in folder
        cd (D(i).name)
        
        % Code
        if ~exist ('spectrum.fig', 'file')
            ensemble_convergence_spectrum();
        end
        % Jump out of folder
        cd ..
    end
end