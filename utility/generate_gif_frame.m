% Generates one frame of a gif. If the first frame is specified, a new gif
% is created. If a subsequent frame number is specified, the frame is
% appended to the existing gif.
% The existing gif is overwritten without warning, so be careful!
%
% Input
%     gif_filename (string): full gif filename
%     frame_index: frame index (1 for first frame and so on; first frame
%       generates gif, which is necessary for subsequent frames)
%     frame_delay (optional): seconds of frame delay (default 0.5s)
%     include_axes (optional, boolean): include axes in output gif or not

function generate_gif_frame(gif_filename, frame_index, frame_delay, include_axes)

% Experimental: eliminates weird thin MATLAB border
iptsetpref('ImshowBorder','tight')

% Handle input argument cases
if nargin == 2
    frame_delay = 0.5;
    include_axes = false;
elseif nargin == 3
    include_axes = false;
elseif nargin == 4
else
    error('Not enough input arguments.');
end

% Grab frame; include axes or not
if include_axes
    frame = getframe(gcf);
else
    frame = getframe();
end

% Convert frame to image
im = frame2im(frame);
% Extract image matrix and colourmap
[im_matrix, cmap] = rgb2ind(im, 256);
% Draw to figure
drawnow;
% Set up new gif if frame is designated as first frame, or append frame
if frame_index == 1
    if exist(gif_filename, 'file')
        delete(gif_filename);
        disp 'Overwriting file.';
    end
    imwrite(im_matrix, cmap,...
        gif_filename, 'gif',...
        'LoopCount', Inf,...
        'DelayTime', frame_delay);
else
    imwrite(im_matrix, cmap,...
        gif_filename, 'gif',...
        'WriteMode', 'append',...
        'DelayTime', frame_delay);
end