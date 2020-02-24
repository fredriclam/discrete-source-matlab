function [x, y] = front_spectrum(row_index)
% Domain width
width = 200;

% Check directory
% assert(strcmp(...
%     'c:\users\fredric\desktop\Incoming\Data\C0500',...
%     cd));

D = dir('HOFY*.dat');
for i = 1:length(D)
    % Next file name
    file_name = D(i).name;
    % Import data
    data = importdata(file_name);
    % Select last row: large t front positions h(y,t)
%     row_index = size(data,1); % end
%     row_index = 120;
%     t = data(row_index,1);
    h = data(row_index,2:end);
    
    % Plot front
    % plot(h);
    
    % FFTransform
    f = fft(h-mean(h));
    
    % Spacing in y
    dy = width/length(h);
    % Sampling frequency
    f_s = 1/dy;
    % Spectral resolution
    df = f_s/length(h);
    % Spectral power
    F = imag(f).^2 + real(f).^2;
    % Unwrap, take first half up to Shannon freq
    F = F(1:floor(length(F)/2));
    % Sum F to S (average spectral power)
    if i == 1
        S = F;
    else
        S = S + F;
    end
end
% Get mean from sum in S
S = S / length(D);
% Wave-number (frequency) range
df_range = df*(1:length(F));
% Export
x = log10(df_range);
y = log10(S);