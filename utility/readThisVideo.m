% Read video frames until available
i = 1;
VV = VideoReader('Supp1_v2.mp4');
VW = VideoWriter('output12','MPEG-4');
VW.set('FrameRate', 12);
open(VW);
while hasFrame(VV)
    Q{i} = readFrame(VV);
    writeVideo(VW, Q{i});
    i = i + 1;
end
close(VW);