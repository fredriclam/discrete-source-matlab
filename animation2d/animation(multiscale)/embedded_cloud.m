%% Generate an embedded cloud with desired placement (for animation)


%% Manual Scale 1
scale_1 = 1;
% Start list of all coordinates
x = scale_1*[0.2; 0.28; 0.8];
y = scale_1*[0.8; 0.52; 0.15];

%% Patch Scale 2
scale_2 = 6;
spacing = .5;

patch_length = 0.5* (scale_2 - (scale_1 + 2*spacing));
offset_upper = scale_1 + spacing;
offset_lower = -spacing;

tfm_upper = @(y) offset_upper + patch_length*y;
tfm_lower = @(y) offset_lower - patch_length*y;
tfm_band_x = @(x) scale_1 + (scale_2-scale_1)*x;

x = [x; scale_2*rand(patch_length * scale_2, 1)];
y = [y; tfm_upper(rand(patch_length * scale_2, 1))];

x = [x; scale_2*rand(patch_length * scale_2, 1)];
y = [y; tfm_lower(rand(patch_length * scale_2, 1))];

x = [x; tfm_band_x(rand(scale_1 * (scale_2-scale_1),1))];
y = [y; scale_1 * rand(scale_1 * (scale_2-scale_1),1)];

%% Patch Scale 3
scale_3 = 100;
spacing = 0;

offset_upper = spacing + offset_upper + patch_length;
offset_lower = -spacing + offset_lower - patch_length;
patch_length = 0.5* (scale_3 - (scale_2 + 2*spacing));

tfm_upper = @(y) offset_upper + patch_length*y;
tfm_lower = @(y) offset_lower - patch_length*y;
tfm_band_x = @(x) scale_2 + (scale_3-scale_2)*x;
tfm_band_y = @(y) offset_lower + (offset_upper - offset_lower) * y;

x = [x; scale_3*rand(patch_length * scale_3, 1)];
y = [y; tfm_upper(rand(patch_length * scale_3, 1))];

x = [x; scale_3*rand(patch_length * scale_3, 1)];
y = [y; tfm_lower(rand(patch_length * scale_3, 1))];

x = [x; tfm_band_x(rand(scale_2 * (scale_3-scale_1),1))];
y = [y; tfm_band_y(rand(scale_2 * (scale_3-scale_1),1))];

%% Plot scale 1
% plot(scale_1*[0.2, 0.28, 0.8], scale_1*[0.8, 0.52, 0.15], '.');
% First scale
figure(1); clf;
plot(x,y,'.')
xlim(scale_1*[0, 1]);
ylim(scale_1*[0,1]);

figure(2); clf;
plot(x,y,'.')
xlim([0, scale_2]);
ylim(scale_1/2+[-scale_2/2, scale_2/2]);

figure(3); clf;
plot(x,y,'.')
xlim([0, scale_3]);
ylim(scale_1/2+[-scale_3/2, scale_3/2]);

%% Load to SOLN file
SOLN = [x, y, 1e9+zeros(length(x),1)];
SOLN = sortrows(SOLN,1);
SOLN = [(1:length(x))', SOLN];
SOLN(SOLN(:,2) <= 0.25, 4) = 0;

%% Cutting out particles for stage 2 simulation
% Filter based on x and y
mask = SOLN(:,2) < 1.2*scale_2 & ...
    SOLN(:,3) < offset_upper + 0.2*scale_2 & ...
    SOLN(:,3) > offset_lower - 0.2*scale_2;
SOLN2 = SOLN(mask,:);
SOLN2(:,3) = SOLN2(:,3) + 2.5;

%% Shifting for stage 3
SOLN3 = SOLN;
SOLN3(:,3) = SOLN3(:,3) + 49.5;