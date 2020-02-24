% Find the smallest index (row number in HOFY) usable, above which the
% isotherm would touch the far edge of the domain (edge effects). Queries
% all HOFY files.
% 
% Input:
%     length_x: length of domain in the x-direction (flame propagation dir)
%      default: 200
% Output:
%     ind: the highest legal index

function ind = highest_legal_index(length_x)

if nargin < 1
    disp('Assuming length_x = 200');
    length_x = 200;
end

D = dir('HOFY*.dat');
if isempty(D)
    error('NO DATA ''HOFY*.dat''');
end
% Extract the common (global) mean position of the front over all such
% files
global_max_index = Inf;
for n = 1:length(D)
    % Load in the file
    str = D(n).name;
    % Extract data from file
    data = importdata(str);
    % Strip first column (variable t)
    data = data(:,2:size(data,2));
    % Vector of maxima
    K = max(data,[],2);
    % Initialize "maximum index of legality"
    max_index = length(K);
    % Find lowest index for which there is an illegal isotherm position
    for i = 1:length(K)
        if K(i) >= length_x
            max_index = i-1;
            break
        end
    end
    % Compare to the global index so measured by querying all HOFY files
    if max_index < global_max_index
        global_max_index = max_index;
    end
end
ind = global_max_index;