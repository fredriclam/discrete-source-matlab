% Tool to generate cloud. Watch out! Not sure if the rand function is
% properly seeded or not. Also, be careful not to replace any existing
% clouds.

% cd clouds/200x200

for CLOUD_NUM = 121:140 %
    
    DY = 200; %
    DX = 200; %
    N = DX*DY;
    % aspect = 1; % x to y
    % linear_density_y = 10;
    % density = 1;
    % Ly = N/linear_density_y;
    % Lx = linear_density_y/density;
    
    y = DY*(rand(1,N));
    x = DX*(rand(1,N));
    
    coord = [sort(x);y];
    
    tau = zeros(1,N) + 9e9;
    % Initial ignition width %%%%%%%%%%
    for i = 1:N/10
        tau(i) = 0;
    end
    % Ignite first k particles %%%%%%%%%%
%     for i = 1:50
%         tau(i) = 0;
%     end
    
    id = zeros(1,N);
    for i = 1:N
        id(i) = i;
    end
    
    coord = [id; coord; tau]';
    
    cloud_number = num2str(CLOUD_NUM);
    zeros_to_pad  = 3 - ceil(log10(100+1));
    for i_padding = 1:zeros_to_pad
        cloud_number = ['0' cloud_number];
    end
    
    name = ['cloud_200x200_'  cloud_number]; %%%%
    fileID = fopen(name,'w');
    fprintf(fileID, '%s\n', name);
    for i = 1:N
        fprintf(fileID, '%d\t%f\t%f\t%e\n', ...
            coord(i,1), coord(i,2), coord(i,3), coord(i,4) );
    end
end
