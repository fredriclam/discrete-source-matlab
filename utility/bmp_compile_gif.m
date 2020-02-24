% Compiles bmp's with similar names to single .gif file

% function bmp_compile_gif(path, root, i_start, i_end, frame_delay)

% path = 'C:\Users\Fredric\Documents\OpenGL\ogl-OpenGL-tutorial_0015_33\tutorial04_colored_cube\2';
root = 'frame';
i_start = 1;
i_end = 120;
% frame_delay = 0.1;

last_path = cd;
% cd(path);

% Video tool create video writer object (1/3)
videobuffer = VideoWriter('ak','MPEG-4');
% Set frame rate
videobuffer.FrameRate = 10;
% Open
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