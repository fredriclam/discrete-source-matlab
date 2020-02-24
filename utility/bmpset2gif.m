% Compiles set of bitmaps (.bmp) with similar names to single .gif file

% function bmp_compile_gif(path, root, i_start, i_end, frame_delay)

path = './';
root = 'frame';
i_start = 1;
i_end = 960;
% frame_delay = 0.4;

last_path = cd;
% cd(path);

% Video tool create video writer object (1/3)
videobuffer = VideoWriter('ThreePointFinal1','MPEG-4');
set(videobuffer,'FrameRate', 60);
open(videobuffer);

% Command to discard MATLAB plot borders
% iptsetpref('ImshowBorder','tight');

for i = i_start:i_end
    % Get frame's file name, auto grab extension
    name = [root num2str(i)];
    D = dir([name '.*']);
    name = D(1).name;
    
    % Read bmp image
    matrix = imread(name);
    figure(1);
    imshow(matrix);
    drawnow;
    
    % Output gif frame
%     generate_gif_frame('compiled_output2.gif',i-i_start+1,frame_delay,false);
    
    
    % Video tool get frame (2/3)
    frame = getframe;
    writeVideo(videobuffer,frame);
    
end

% Video tool close (3/3)
close(videobuffer);

cd(last_path);