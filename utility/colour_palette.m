% Colour palette
%   Inspect custom colour palette. Use return argument to get MATLAB RGB
%   (0~1).

function [col] = colour_palette(n)
if nargin == 0
    n = 0;
end

palette = {...
    [236 177 32]/255,...
    [191 0 191]/255,...
    [0 114 189]/255,...
    [0 127 0]/255,...
    [164 170 214]/255,...
    [255 102 102]/255,...
    [109 196 151]/255
    };

if nargout == 0
    % Plot to figure 37 as bands
    figure(1337);
    hold on
    for i = 1:length(palette)
        fill([0 1 1 0],[-1 -1 0 0]+i,palette{i});
    end
    axis auto
    % Print palette
    for i = 1:n
        disp(palette{i}*255)
    end
else
    index = mod(n,length(palette));
    if index == 0
        index = length(palette);
    end
    col = palette{index};
end