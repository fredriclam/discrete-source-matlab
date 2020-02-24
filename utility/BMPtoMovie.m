% Open first frame to calibrate figure size
figure;
i = 1;
filePath = ['frame' num2str(i) '.bmp'];
imshow(imread(filePath));

% Create video writer object
m_bay = VideoWriter('MovieOutput','MPEG-4');
m_bay.set('FrameRate', 20);
open(m_bay);

D = dir('frame*.bmp');
for i = 1:length(D)
    filePath = ['frame' num2str(i) '.bmp'];
    imshow(imread(filePath));
    writeVideo(m_bay, getframe(gcf));
end
close(m_bay);
disp('Done')