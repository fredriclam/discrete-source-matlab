fid = fopen(file_name_tfld);
page_size = x_res*y_res*z_res;
fmt = '%f';
% data = zeros(page_size,1);
c = textscan(fid,fmt,page_size);
c = textscan(fid,fmt,page_size);

data = c{1};
claer c;

% set(0,'DefaultFigureRenderer','opengl')