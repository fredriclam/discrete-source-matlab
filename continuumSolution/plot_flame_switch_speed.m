% Plots the flame speed according to continuum switch-type model (see
% 1DFlameSwitchTypeModel_XCM.pdf)

RES = 100;
x_vector = linspace(0,1,RES);
y_vector = x_vector;
for i = 1:length(x_vector);
    y_vector(i) = flame_switch_speed(x_vector(i));
end
semilogy(x_vector,y_vector);