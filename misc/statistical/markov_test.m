% Coupling matrix (coupling between cells of previous sheet and current
% sheet)
A = [1 1 0 1 0 0 0 0 0; 1 1 1 0 1 0 0 0 0; 0 1 1 0 0 1 0 0 0;...
    1 0 0 1 1 0 1 0 0; 0 1 0 1 1 1 0 1 0; 0 0 1 0 1 1 0 0 1;...
    0 0 0 1 0 0 1 1 0; 0 0 0 0 1 0 1 1 1; 0 0 0 0 0 1 0 1 1];

% Generate left transition matrix B from column normalization
B = A;
for i = 1:size(A,2)
    B(:,i) = A(:,i) / norm(A(:,i),1);
end

% Eigendecomposition
[R, LAMBDA] = eig(B);
filter = LAMBDA == 1;
% Select unique eigenvector with unit eigenvalue
assert(sum(sum(filter)) == 1)
index = find(sum(filter,2),1);
% Steady-state vector
v = R(:,index);