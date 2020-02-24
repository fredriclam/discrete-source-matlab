% Plots colour map of switch-type flame continuum solution (see
% 1DFlameSwitchTypeModel_XCM.pdf)

RES = 401;
FONT_SIZE = 16;
position_offset = 150.;
new_x_axis = linspace(0,200,RES);
field_vector = new_x_axis;
for i = 1:RES
    field_vector(i) = exact_flame_solution(new_x_axis(i) - position_offset, 0.05, 1e2);
end

field = zeros(RES,RES);
for i = 1:RES
    field(:,i) = field_vector';
end

contourf(new_x_axis,new_x_axis,field,...
    'LineStyle', 'none', 'LevelStep', 0.01);

colormap hot;
caxis([0, 1]);
set (gca, 'DataAspectRatio', [1 1 1]);
set(gca, 'fontname', 'Times New Roman', 'fontsize', FONT_SIZE)