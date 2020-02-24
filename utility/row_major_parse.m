% Parse value sequence into matrix properly (x varies from col to col)
% from row-major to column-major (4-D).
function Z_o = row_major_parse(data, x_res, y_res, z_res, t_res)
% Read iterator
it = 1;
% Pre-allocate matrix
Z_o = zeros(y_res, x_res, z_res, t_res);
while it < length(data)
    % 4th index
    l = floor((it-1)/(z_res*y_res*x_res))+1;
    % Iterator residual
    it_z1 = it - (l-1)*z_res*y_res*x_res;
    
    % 3rd index
    k = floor((it_z1-1)/(y_res*x_res))+1;
    % Iterator residual
    it_z2 = it_z1 - (k-1)*y_res*x_res;
    
    % Row and column indices
    i = floor((it_z2-1)/x_res)+1;
    j = mod(it_z2-1,x_res)+1;
    
    % Copy
    Z_o(i,j,k,l) = data(it);
    % Increment read iterator
    it = it + 1;
end