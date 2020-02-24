% Example usage of swiss_cheese_run and swiss_cheese_run_slab
clc; close all;

% Cylinder run demo
figure(1);
D = 1; diameter = 2; length = 20; density = 3;
[cylinder_success, cylinder_time_of_travel] = ...
    swiss_cheese_run(D,diameter,length,density,true);

% Slab run demo
figure(2);
D = 1; thickness = 2; length = 10; width = length; density = 1;
[slab_success, slab_time_of_travel] = ...
    swiss_cheese_run_slab(D,thickness,length,width,density,true);