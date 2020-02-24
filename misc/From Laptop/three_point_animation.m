% Generates animation with three particles that release heat in succession
% after ignition (temperature reaches prescribed threshold)

gif_filename = 'three_point.gif';

x1 = 0.18643;
y1 = 0.8977587;
t01 = 0;

x2 = 0.425344;
y2 = 0.877075;
t02 = 0.0039;

x3 = 0.637258;
y3 = 0.351752;
t03 = 0.0593;

x = [x1 x2 x3];
y = [y1 y2 y3];
% plot(x,y);
% axis([0,1,0,1]);

G = @(x,y,x0,y0,t,t0) 1/4/pi/(t-t0)*exp(-((x-x0)^2+(y-y0)^2)/4/(t-t0));
G_global = @(x,y,t) G(x,y,x1,y1,t,t01) + ...
    heaviside(t-t02)*G(x,y,x2,y2,t,t02) + ...
    heaviside(t-t03)*G(x,y,x3,y3,t,t03);

figure(7);
hold on;
axis([0,1,0,1]);

RES = 120;
GRID = 100;
MKSIZE = 36;

dt = 0.08/RES;
dx = 1/GRID;
dy = 1/GRID;
x_grid = 0:dx:1;
y_grid = 0:dy:1;
Z = zeros(size(x_grid,2),size(y_grid,2));
for i = 1:RES
    clf;
    t = i*dt;
    for m = 1:GRID
        for n = 1:GRID
            Z(m,n) = G_global(m*dx,n*dy,t);
        end
    end
    contour_handle = contourf(1-x_grid, 1-y_grid, Z,...
        'LineStyle', 'none', 'LevelStep', 0.01);
    hold on;
    axis([0,1,0,1]);
    caxis([0 2]);
    pbaspect([1 1 1]);
    colormap hot;
    plot(1-y1,1-x1,'k.','MarkerSize', MKSIZE)
    if t > t02;
        plot(1-y2,1-x2,'k.','MarkerSize', MKSIZE);
    else
        plot(1-y2,1-x2,'w.','MarkerSize', MKSIZE);
    end
    if t > t03;
        plot(1-y3,1-x3,'k.','MarkerSize', MKSIZE);
    else
        plot(1-y3,1-x3,'w.','MarkerSize', MKSIZE);
    end
    frame = getframe();
    im = frame2im(frame);
    [im_matrix, cmap] = rgb2ind(im, 256);
    drawnow;
    if i == 1
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
    
    % Save figure
    savefig(['frame' num2str(i) '.fig']);
end
    
    