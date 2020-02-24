% Returns a 3x1 colour vector for use with parameter 'Color' in plotting.
% Cycles through the rainbow.
%
% Input
%     i: (integer) current iteration (1 <= i <= N)
%     N: (integer) total population
% Output
%     colour_vector: [r g b] format with each between 0 and 1
%
% Usage example
%   for i = 1:N
%       plot(x, y, 'Color', colour_vector(i,N))
%   end

function colour_vector = get_rainbow_colour (i, N)

USAGE_FACTOR = 0.85;
phase = USAGE_FACTOR * 2*pi * i / N;
r = 0.5 * (1 - cos(phase + 2*pi/3 + pi/6));
g = 0.5 * (1 - cos(phase - 0*pi/3+ pi/6));
b = 0.5 * (1 - cos(phase - 2*pi/3+ pi/6));
colour_vector = [r g b];

% Testing tri-sine colour
% figure(1);
% k = 1;
% for phase = linspace(0,1,250)
%     phase = 2*pi * phase;
%     r = 0.5 * (1 - cos(phase + 2*pi/3 + pi/6));
%     g = 0.5 * (1 - cos(phase - 0*pi/3+ pi/6));
%     b = 0.5 * (1 - cos(phase - 2*pi/3+ pi/6));
%     hold on
%     plot(linspace(-1,1,10), k + linspace(-1,1,10), 'Color', [r g b]);
%     k = k + 1;
% end
% % Sub sine-sine-flat colour testing
% k = 1;
% figure(1);
% for phase = linspace(0,1,250)
%     r = colour_wave(phase+1/3);
%     g = colour_wave(phase);
%     b = colour_wave(phase-1/3);
%     hold on
%     plot(linspace(-1,1,10), k + linspace(-1,1,10), 'Color', [r g b]);
%     k = k + 1;
% end
% figure(2);
% x = linspace(0,1,250);
% out_value = zeros(1,250);
% for i = 1:250
%     out_value(i) = colour_wave(x(i)-1/3);
% end
% plot(x,out_value);
% function value = colour_wave (phase)
% % Extract decimal portion
% phase = phase - floor(phase);
% scale = 3*pi;
% % if phase > 2/3
% %     value = 0;
% % else
% %     phase = phase .* scale;
% %     value = 0.5 * (1 - cos(phase));
% % end
% 
% end