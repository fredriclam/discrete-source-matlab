% Deprecated with scaling_PROP_analysis

function [prim_dimension, percent_propagated]=...
    binarize_data(Q, go_threshold)
% Sort data
indata = sortrows(Q,1);
% Get column vector: primary dimension
prim_dimension = indata(:,1);
% Get matrix of propagation percentages
prop_percentages = indata(:,2:end);
% Filter
go_matrix = prop_percentages > go_threshold;
% Average propagation percentage
percent_propagated = sum(go_matrix,2)/size(go_matrix,2);
% % Quick plot
% plot(dimension,pperc);