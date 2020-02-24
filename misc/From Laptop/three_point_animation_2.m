% Generates animation with three particles that release heat in succession
% after ignition (temperature reaches prescribed threshold)

gif_filename = 'three_point.gif';

% Use OpenGL
set(0, 'DefaultFigureRenderer', 'zbuffer');

% Video tool create video writer object (1/3)
% videobuffer = VideoWriter('CylinderOpen','MPEG-4');
% open(videobuffer);

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

G = @(x,y,x0,y0,t,t0) min(2, ...
    1/4/pi/(t-t0)*exp(-((x-x0)^2+(y-y0)^2)/4/(t-t0)));
G_global = @(x,y,t) G(x,y,x1,y1,t,t01) + ...
    heaviside(t-t02)*G(x,y,x2,y2,t,t02) + ...
    heaviside(t-t03)*G(x,y,x3,y3,t,t03);

figure(7);
hold on;
axis([0,1,0,1]);

RES = 240;
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
    
%     tracked(i) = G_global(0.637258, 0.351752,t);
    
    for m = 0:GRID
        for n = 0:GRID
            Z(m+1,n+1) = G_global(m*dx,n*dy,t);
        end
    end
    contour_handle = contourf(1-x_grid, 1-y_grid, Z,...
        'LineStyle', 'none', 'LevelStep', 0.01);
    hold on;
    axis([0,1,0,1]);
    axis off
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
    drawnow;
    
    name = ['frame' num2str(i)];
    print(name,'-dbmp');
    % Video tool get frame (2/3)
%     frame = getframe;
%     writeVideo(videobuffer,frame);
    
end
    
% close(videobuffer);