% Specify corner position (least x, y, z), dimensions
function h = draw_voxel(pos, dim, colour, alpha, centre)

if nargin <= 1
    error('Not enough input arguments!');
end
if nargin <= 2
    colour = [1 1 1];
end
if nargin <= 3
    alpha = 1;
end
if nargin <= 4
    centre = 1;
end

% If centre == true, transform centre position to corner position
if centre
    corner_pos = pos - 0.5*dim;
else
    corner_pos = pos;
end

% Generate vertices
V = zeros(8,3);
for i = 0:1
    for j = 0:1
        for k = 0:1
            V(4*i + 2*j + k + 1,:) = ...
                corner_pos + dim .* [i, j, k];
        end
    end
end
% Generate faces
F = [1 3 4 2;
     5 7 8 6;
     1 2 6 5;
     3 4 8 7;
     1 3 7 5;
     2 4 8 6];

patch('Vertices', V,...
    'Faces' , F,...
    'FaceColor', colour,...
    'FaceAlpha', alpha,...
    'LineStyle', 'none');