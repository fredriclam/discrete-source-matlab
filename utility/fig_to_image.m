% Generates animated gif from series of .fig files saved in the current
% local directory. Reads in the specified number of .fig files all named as
% '[lexical_root]#', e.g. someplot1.fig, someplot2.fig ...
%
% Calls generate_gif_frame, which overwrites any existing .gif file with
% the exact same name.
%
% Input
%     lexical_root (string): name of .fig files to be read in, minus the
%      figure number and the suffix .fig 
%     num_frames: number of frames to read up to
%     frame_delay (optional): seconds of frame delay (default 0.5s)
%     include_axes (optional, boolean): include axes in output gif or not
%
% See also generate_gif_frame.

function fig_to_image (lexical_root, num_frames, frame_delay, include_axes)

if nargin < 2
    error('Not enough input arguments.');
end

if nargin < 3
    frame_delay = 0.25;
end  

if nargin < 4
    include_axes = false;
end

% Name output gif filename
gif_filename = ['ani-' lexical_root '.gif'];

for i = 1:num_frames
    % Open figure in current directory
    open([lexical_root num2str(i) '.fig']);
    
    axis ([-.5, 3.3, -3, 1]); drawnow;
    % Generate gif frame
    generate_gif_frame(gif_filename, i, frame_delay, include_axes);
    % Close the current figure
    close(gcf);
end