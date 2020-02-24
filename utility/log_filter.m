% Samples equally spaced data into roughly exponentially spaced data so
% that the log of the vector is roughly equally spaced in the log log plot.
%
% Input
%     X: linear spaced
%     Y: linear spaced
%     dt: spacing in natural log scale; kind of arbitrary
% Output
%     output_x: exponentially spaced (same data)
%     output_y: exponentially spaced (same data)

function [x_output, y_output] = log_filter(X,Y,dt)

% Default dt = 0.15 (arbitrarily chosen)
if nargin ~= 2
    dt = 0.15;
elseif nargin ~= 3
    error('Not enough input arguments.');
end

% i = 2; % 2 (TIGN040) or 1 
i = 1;
% dt = 0.15; % 0.15 (TIGN040) or 0.25 
% Examine data in natural log spce
data = [X Y];
logdata = [log(X) log(Y)];
% % If more than 2 columns, choose only first and third column
% if size(logdata,2) > 2
%     logdata(:,2) = logdata(:,3);
%     logdata = logdata(:,1:2);
% end

% % plot raw data
% plot(logdata(:,1),logdata(:,2),'b');
% hold on

it_output = 1;
done = false;
filtered = zeros(1,2);
while i < size(logdata,1)
    % set t
    t = 0; %logdata(i,1);
    while t < dt && i < size(logdata,1)
        t = t + logdata(i+1,1) - logdata(i,1);
        i = i + 1;
        if i >= size(logdata,1) && t < dt
            % done
            done = true;
        end
    end
    if ~done
        filtered(it_output,:) = data(i,:);
    end
    it_output = it_output + 1;
end

% plot(filtered(:,1), filtered(:,2), 'r*');
x_output = filtered(:,1);
y_output = filtered(:,2);