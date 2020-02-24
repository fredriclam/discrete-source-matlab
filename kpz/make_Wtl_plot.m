% Generates matrix of data for W against t, l.
% Requires manually entering L (phyiscal width of domain) and maximum
% number of grid points in the width of the domain.
%
% Generates 3-D plot of W against t, l.
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



% function [t_vector, l_vector, sum_W_matrix] = make_Wtl_plot
% Grab data

% Physical width of domain
L = 100;
% Maximum number of grid points in width
max_grid_points = 1000;

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
    t_index_vector = 1:246; % % % MANUAL
    % N.B. (above): hli(1000), NOT highest_legal_index(100) -> 251 (0.025)
    % Saved previous values: 165, 14
    
    % Get vector of physical t
    t_vector = t_vector_full(t_index_vector);
    % Vector of number of grid points (integer) to sample 
    l_vector = 2:1:max_grid_points;
    % Index corresponding to the middle of the width of the domain
    MID_VALUE = max_grid_points/2;
    
    % Pre-allocation
    W_matrix = zeros(length(l_vector),length(t_vector));
    
    % Generate W(l) (matched to t_vector)
    for j = 1:length(t_vector)
        for i = 1:length(l_vector)
            % Integer l: number of grid points
            l = l_vector(i);
            % Calculate lower and upper indices
            lower_index = floor(MID_VALUE+1-l/2);
            upper_index = floor(MID_VALUE+l/2);
            % Temporary value: grab h values at time t(j), using window
            % size l(i)
            work_h = h_matrix(t_index_vector(j),...
                lower_index:upper_index);
            % Save W (scalar value) to W_matrix
            W_matrix(i,j) = W_fn(work_h);
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
% Bessel correction
sum_W_matrix = sum_W_matrix ./ (num_samples-1);

% Generate plot
figure(17);
surf(t_vector, l_vector, sum_W_matrix);
x_str = '\itt';
y_str = '\itl';
title_str = '\itW';
xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
title (title_str,'FontName','Times New Roman','FontSize', 24);
adjplot;

% Various experimental plots
%
% Previous description:
% Generates four plots describing the behaviour of W as a function of t and
% l (l being the transverse width considered; note that l < L, which is the
% system size; but since there are periodic boundary conditions it need not
% be the case that l << L, since edge effects are gone.)
% 
% 
% % Logarithmic surface
% figure(12);
% logt = log(t_vector);
% logl = log(l_vector);
% logW = log(sum_W_matrix);
% surf(logt, logl, logW);
% x_str = 'ln \itt';
% y_str = 'ln \itl';
% title_str = 'ln \itW';
% xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
% ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
% title (title_str,'FontName','Times New Roman','FontSize', 24);
% adjplot;
% 
% % Difference in t
% figure(13);
% ddtW = diff(logW,1,2);
% % Get new t scale
% t1 = [t_vector; 0];
% t2 = [0; t_vector];
% t_reduced = (t1 + t2)/2;
% t_reduced = t_reduced(2:length(t_reduced)-1);
% logtr = log(t_reduced);
% % Plot
% surf(logtr, logl, ddtW);
% title_str = '$\frac{\partial [\ln W]}{\partial [\ln t]}$';
% x_str = 'ln \itt';
% y_str = 'ln \itl';
% xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
% ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
% title (title_str,'Interpreter', 'latex', 'FontName','Times New Roman',...
%     'FontSize', 24);
% adjplot;
% 
% % Difference in l
% figure(14);
% ddlW = diff(logW,1,1);
% % Get new l scale
% l1 = [l_vector, 0];
% l2 = [0, l_vector];
% l_reduced = (l1 + l2)/2;
% l_reduced = l_reduced(2:length(l_reduced)-1);
% loglr = log(l_reduced);
% % Plot
% surf(logt, loglr, ddlW);
% title_str = '$\frac{\partial [\ln W]}{\partial [\ln l]}$';
% x_str = 'ln \itt';
% y_str = 'ln \itl';
% xlabel (x_str,'FontName','Times New Roman','FontSize', 24);
% ylabel (y_str,'FontName','Times New Roman','FontSize', 24);
% title (title_str,'Interpreter', 'latex', 'FontName','Times New Roman',...
%     'FontSize', 24);
% adjplot;