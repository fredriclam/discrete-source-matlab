N = 40000;
W_X = 200;
W_Y = 200;
x = W_X*(rand(1,N)-0.5);
y = W_Y*(rand(1,N)-0.5);

x1 = 0.18643;
y1 = 0.8977587;

x2 = 0.425344;
y2 = 0.877075;

x3 = 0.637258;
y3 = 0.351752;

MKSIZE = 36;

mask = (x < 1 & x > 0) & (y < 1 & y > 0);
x(mask) = [];
y(mask) = [];
x = [x x1 x2 x3];
y = [y y1 y2 y3];

x = 1-x;
y = 1-y;
temp = y;
y = x;
x = temp;

figure(99);

% Logistics curve
F_max = 100; % Max stretch factor
k = 10; % Steepness
lc = @(x) F_max ./ ( 1 + exp(-k*(x-0.5))) .* x.^0.5; % between -1 and 1

NUM_FRAMES = 400;
for i = 0:NUM_FRAMES
    % Compute stretch factor
    if i == 0
        factor = 0;
    else
        factor = lc(i/NUM_FRAMES); % max 100
    end
    
    % Vector describing region
    region = [0,1,0,1]+factor*[-1,1,-1,1];
    
    % Compute area of zoom level (also relative area)
    area = (region(2) - region(1) ) * (region(4)-region(3));
    
    % Compute adjusted marker size
    current_size = MKSIZE / area;
    
    % Generate plot
    plot(x,y,'k.','MarkerSize', current_size);
    axis off
    pbaspect([1 1 1]);
    
    % Zoom
    axis(region);
    set(gca,'Units','normalized','Position',[0,0,1,1]);
    
    % Debug
%     pause(1/30);
    
    frame_num = i+1;
    print(['zoomframe' num2str(frame_num)],'-dbmp');
end