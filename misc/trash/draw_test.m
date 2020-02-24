% Z1 = double(squeeze(Z));
% h = slice(Z1, [], [], 1:size(Z1,3));
% set(h, 'EdgeColor', 'none', 'FaceColor', 'interp');
% alpha(.1);

clf
clim = [0, 1];

% set(0,'DefaultFigureRenderer','opengl')

dx = width_x/x_res;
dy = width_y/y_res;
dz = width_z/z_res;
Z1 = Z(:,:,:,1);
caxis(clim);
cax = caxis;
cm = colormap('hot');
theta_to_colour = @(theta) ...
    cm(min(max(...
        floor(64*(theta-cax(1))/(cax(2)-cax(1))),...
    1),64),:);
theta_to_alpha = @(theta) ...
    min(max(...
        0.01*theta/cax(2)-0.002,...
    0.),1);
null_colour = cm(1,:);

for i = 1:length(y_vector)
    for j = 1:length(x_vector)
        for k = 1:length(z_vector)
            % Get voxel draw coordinate
            y = y_vector(i);
            x = x_vector(j);
            z = z_vector(k);
            
            if y^2 + z^2 < 0.25*width_y*width_z
                theta = Z1(i,j,k);
                colour = theta_to_colour(theta);
%                 if colour ~= null_colour
                    alpha = theta_to_alpha(theta);
                    draw_voxel([x y z], [dx dy dz], colour, alpha, true)
%                 end            
            end
        end
    end
end

daspect([1 1 1]);
campos([116.561347635427,65.8533497614451,32.8381683531091]);
set(gca,'Color', 'Black');