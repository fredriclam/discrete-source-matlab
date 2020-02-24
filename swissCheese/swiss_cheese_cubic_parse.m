% Parse cubic data
cd 'C:\Users\Fredy\Documents\Visual Studio 2013\Projects\SCNetwork\Release'
% cd 'C:\Users\Fredy\Documents\Visual Studio 2013\Projects\SCNetwork\Release'

D = dir('cubic_data*.txt');
imported_chunk = importdata(D.name);
 
% Format note (data.txt): row: varies domain height; outside loop: density
% density_vector = linspace(320,640,100);
% domain_height_vector = linspace(0.02,0.12,100);

%% Reprocess
aspect_ratio_samples = 20;
density_samples = 20;
height_samples = 40;

aspect_ratio_range = [10, 100];
density_range = [50, 100];
height_range = [.15, .6];

aspect_ratio_vector = linspace(aspect_ratio_range(1), ...
    aspect_ratio_range(2), aspect_ratio_samples);
density_vector = linspace(density_range(1), ...
    density_range(2), density_samples);
height_vector = linspace(height_range(1), ...
    height_range(2), height_samples);

processed_data_flipped = reshape(imported_chunk',...
    [height_samples, density_samples, aspect_ratio_samples]);

clear processed_data;
for i = 1:size(processed_data_flipped,3)
    processed_data(:,:,i) = processed_data_flipped(:,:,i)';
end

% %% Surf
% I = 1;
% surf(height_vector, density_vector, processed_data(:,:,I));
% view([0,90])

%% Stacko
for I = 1:aspect_ratio_samples
    figure(331);
    subplot(4,5,I);
    surf(height_vector, density_vector, processed_data(:,:,I),...
        'LineStyle', 'None');
    view([0,90])
    xlabel 'height'
    ylabel 'dens'
end

%% Squeeze data
crit_height_matrix = zeros(aspect_ratio_samples, density_samples);
for j = 1:aspect_ratio_samples
    Q = processed_data(:,:,j);
    for i = 1:size(Q,1)
        crit_height_matrix(j,i) = swiss_cheese_squeeze(height_vector, Q(i,:));
    end
end

%% Plot crit_height_matrix as lines
figure(6);
plot(density_vector, crit_height_matrix);

%% Plot as surf
figure(7);
surf(density_vector, aspect_ratio_vector, crit_height_matrix);
xlabel 'density'
ylabel 'aspect'
zlabel 'critical_height'