% Generates matrix of data for W against t, l, using "statistical
% balancing." This so-called balancing takes windows of size l and
% replicates them over the domain width L, so that each l case uses the
% same number of grid points for averaging.
% 
% * Manually enter L (phyiscal width of domain) and maximum
% number of grid points in the width of the domain.
%
% Can generates 3-D plot of W against t, l.
%
% Uses all HOFY files in current directory.
%
% Figures produced:
%     17: W(t, l) surface
% Output:
%     t_vector: vector of problem t
%     l_vector: vector of number of indices used; NOT PHYSICAL l
%     sum_W_matrix: actually W averaged over all runs in directory
% Example plotting format:
%     surf(t_vector, l_vector, sum_W_matrix)

% function [t_vector, l_vector, sum_W_matrix] = make_Wtl_plot_stat_balance

% Physical width of domain
L = 100;
% Maximum number of grid points in width
max_grid_points = 1000;

samples = [2, 4, 5, 8, 10, 20, 25, 40, 50, 100, 125, 200, 250, 500 ,1000];

D=dir('HOFY*');
num_samples = length(D);
% Width from vector v of heights h(y)
W_fn = @(v) sqrt(mean((v - mean(v)).^2));

for n = 1:num_samples
    E = importdata(D(n).name);
    % Separate data matrix
    t_vector_full = E(:,1);
    h_matrix = E(:,2:size(E,2));

    % Get range of legal indicies
    t_index_vector = 1:246; % hli = 14 WATCH OUT! 246/251
    % Get vector of physical t
    t_vector = t_vector_full(t_index_vector);
    % Vector of number of grid points (integer) to sample 
    lind_vector = samples;
    
    % Pre-allocation
    W_matrix = zeros(length(lind_vector),length(t_vector));
    
    % Generate W(l) (matched to t_vector)
    for j = 1:length(t_vector)
        for i = 1:length(lind_vector)
            % Get integer window size
            lind = samples(i);
            % Get integer number of windows to copy along domain
            copies = 1000/lind;
            sum = 0;
            for k = 1:copies
                slice = h_matrix(j,...
                    1+(k-1)*lind:k*lind);
                sum = sum + W_fn(slice);
            end
            W_matrix(i,j) = sum/copies;
%             % Integer l: number of grid points
%             l = lind_vector(i);
%             % Calculate lower and upper indices
%             lower_index = floor(MID_VALUE+1-l/2);
%             upper_index = floor(MID_VALUE+l/2);
%             % Temporary value: grab h values at time t(j), using window
%             % size l(i)
%             work_h = h_matrix(t_index_vector(j),...
%                 lower_index:upper_index);
%             % Save W (scalar value) to W_matrix
%             W_matrix(i,j) = W_fn(work_h);
        end
    end
    % Add to sum across different runs
    if n == 1
        sum_W_matrix = W_matrix;
    else
        sum_W_matrix = sum_W_matrix + W_matrix;
    end
end
% Calculate average from sum
sum_W_matrix = sum_W_matrix ./ num_samples;

% % Generate plot
% figure(17);
% surf(t_vector, l_vector, sum_W_matrix);
% x_str = '\itt';
% y_str = '\itl';
% title_str = '\itW';
% xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
% ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
% title (title_str,'FontName','Times New Roman','FontSize', 24);
% adjplot;