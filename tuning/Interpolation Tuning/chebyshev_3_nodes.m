% Finds the minimum time-centre for a specified tolerance as a "function"
% of both x and y. Chebyshev Newton polynomial, corrected. Outputs a plot
% of the minimum c ("pivot" of the polynomial) over x and y, for the
% specified domain length.

%  3 nodes

clear all; clc; close all;
h_max = 1e-3;
h = h_max; % Alias
L = 6;
tol_periodic = 1e-9;
error_allowable = 1e-9;
NODES = 3;

f = zeros(1,NODES);
node = f;
coeff = f;
temp = f;

% Cheb: computes chebyshev nodes, i = 1 to n;
% Cheb 3 to 5: maps the nodes of a 3-node interpolation to the nodes of a
% 5-node polynomial
cheb = @(i,n) 1/2 + 1/2*cos((2*(i-1)+1)*pi/(2*(n)));
cheb_3_to_5 = @(i) 1/2 + 1/2*cos((2*((2*i-1)-1)+1)*pi/(2*(5)));

% theta = @(r,t) heaviside(t) .* ...
%     1./(4*pi*(t)).^(3/2).*exp(-r.^2./(4*(t)));

G = @(x, y, t, L, tol) images_green_2d_diag(x, y, t, L, tol);

% Number of sample points to use for r, Taylor centre, and time samples
x_samples = 300/10; %250;
y_samples = 25*2/5;
c_samples = 300/10; %250*2;
t_samples = 25*2/5;
c_start = 0.27;

% r_range = linspace(0.005, 0.5, r_samples);
x_range = linspace(0, 1.6, x_samples);
y_range = linspace(0, L/2, y_samples);
c_range = linspace(c_start, 0, c_samples);
% Output vector
c_min = zeros(y_samples,x_samples);
% Iteration count
m = 1;
for x = x_range
    max_err_at_r = 0;
    c_min_at_r = 0;
    n = 1;
    for y = y_range
        for c = c_range
            % Compute Newton coefficients
            for i = 1:NODES
%                 node(i) = cheb(NODES+1-i,NODES);
                node(i) = cheb(NODES+1-i, NODES); %%%%%%%%%%%%%
            end
            % Compute at points
            for i = 1:NODES
                coeff(i) = G(x, y, c+h*(node(i)), L, tol_periodic);
            end
            % Compute Newton coefficients
            for i = 1:NODES
                for j = i+1:NODES
                    temp(j) = (coeff(j) - coeff(j-1))/...
                        (h*(node(j)-node(j-i)));
                end
                for j = i+1:NODES
                    coeff(j) = temp(j);
                end
            end
            
            % Construct t vector
            t_range = linspace(c,c+h_max,t_samples); %%%
            current_error = 0;
            for t = t_range
                % Compute error compared to Taylor polynomial
                % Evalute Newton polynomial
                P = 0;
                for i = NODES:-1:1
                    P = P * (t - (c + h*node(i)));
                    P = P + coeff(i);
                end
                error = abs(P-G(x, y, t, L, tol_periodic));
                if ~(error < Inf)
                    current_error = 1000;
                    disp(['x' num2str(x) ' y' num2str(y) ' t' num2str(t)])
                end
                if error > current_error
                    current_error = error;
                end
            end
            if current_error > error_allowable
                c_min_at_r = c;
                break
            end            
        end
        c_min(n,m) = c_min_at_r;
        n = n + 1;
    end
    % Increment iteration counter
    m = m + 1;
end

% Plot
surf(x_range, y_range, c_min);
% plot(x_range, c_min);
title ('Lowest Tchebychev left-pivot c vs. x');
xlabel ('x');
ylabel ('y');
zlabel ('Minimum pivot c (time)');
save 'projected-node_3D_nodes_Chebychev pivot L6 with samples x300 y50 c300 t50 c27e-2to0, y full domain max1e-9on1e-3'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
