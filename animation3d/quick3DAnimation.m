% Slideshow of 3D particle visualization with initation zone
t_range = linspace(0,10,100);

xi = Z(:,2);
yi = Z(:,3);
zi = Z(:,4);
t_i = Z(:,5);
for i = 1:length(t_range)
    clf;
    t = t_range(i);
    scatter3(xi(t_i > t),yi(t_i > t),zi(t_i > t),'.'...
        ...,'color',0.15*[1 1 1],'MarkerSize', 0.01
        );
    
    view([45,45])
    hold on
    scatter3(xi(t_i <= t),yi(t_i <= t),zi(t_i <= t),'.'...
        ...,'color',[1 0 0],'MarkerSize', 0.01
        );
    geometry_aspect_ratio = 10;
    diameter = 3;
    % Draw cylinder
    cylinder_path = ones(1,10);
    [z, y, x] = cylinder(cylinder_path);
    cylinder_length = geometry_aspect_ratio*diameter;
    mesh(0.9*cylinder_length*(x)+0.1*cylinder_length,diameter/2*y,diameter/2*z,...
        'FaceColor', 'None',...
        'EdgeColor', [0 0 0],...
        'LineWidth', 0.5)
    % Draw initiation zone
    [z, y, x] = cylinder(ones(1,1));
    mesh(0.1*cylinder_length*x,diameter/2*y,diameter/2*z,...
        'FaceColor', 0.5*[1 1 1],...
        'EdgeColor', [0 0 0],...
        'LineWidth', 0.5,...
        'FaceAlpha', 0.5)
    hold off
    axis off;
    axis equal;
    pause;
end