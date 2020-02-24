% Finds the minimum time-centre for a specified tolerance as a "function"
% of both x and y. Chebyshev Newton polynomial, corrected. Outputs a plot
% of the minimum c ("pivot" of the polynomial) over x and y, for the
% specified domain length.

%  3 nodes

% clear all; clc; close all;
function tauc_polynomial_interpolation
h_max = 1e-1;
h = h_max; % Alias
L = 200;
tr = .1;
% tol_periodic = 1e-9;
error_allowable_percent = 0.04;
error_allowable_linear = 1e-9;

values = load('ei_table_0to25by1e-4.dat');
keys = 0:1e-4:25+1e-4;
values = values';
table = [keys; values];

% Cheb: computes chebyshev nodes, i = 1 to n;
% Cheb 3 to 5: maps the nodes of a 3-node interpolation to the nodes of a
% 5-node polynomial
cheb = @(i,n) 1/2 + 1/2*cos((2*(i-1)+1)*pi/(2*(n)));
cheb_5_to_3 = @(i) 1/2 + 1/2*cos((2*((2*i-1)-1)+1)*pi/(2*(5)));
cheb_5_to_2a = @(i) 1/2 + 1/2*cos((2*((2*i)-1)+1)*pi/(2*(5))); %2,4
cheb_5_to_2b = @(i) 1/2 + 1/2*cos((2*((4*i-3)-1)+1)*pi/(2*(5))); %1,5
cheb_5_to_1 = @(i) 1/2; % Only useful for t > ~250...useless

NODES = 5;
f = zeros(1,NODES);
node = f;
coeff = f;
temp = f;

% theta = @(r,t) heaviside(t) .* ...
%     1./(4*pi*(t)).^(3/2).*exp(-r.^2./(4*(t)));

% G = @(x, y, t, L, tol) images_green_2d_diag_correct(x, y, t, L, tol);
G = @(x, y, t, L, tr) T_i_tr_boss(t, x.^2 + y.^2, tr,table,-1e-4,25) + ...
    T_i_tr_boss(t, x.^2 + (y + L).^2, tr,table,-1e-4,25) + ...
    T_i_tr_boss(t, x.^2 + (y - L).^2, tr,table,-1e-4,25);

% Number of sample points to use for r, Taylor centre, and time samples
x_samples = 8;%50; %20;
y_samples = 8; %32; %8
c_samples = 10; %25; %500;
t_samples = 25; %25; %50
c_start = .25;

x_max = 1e-7;
y_max = 1e-7;

% r_range = linspace(0.005, 0.5, r_samples);
x_range = linspace(0, x_max, x_samples);
y_range = linspace(0, y_max, y_samples);
c_range = linspace(c_start, 0, c_samples);
% Output vector
c_min = zeros(y_samples,x_samples);
% Iteration count
m = 1;
for x = x_range
    disp([num2str(m), '/' ,num2str(length(x_range))]);
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
                coeff(i) = G(x, y, c+h*(node(i)), L, tr);
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
                % Hybrid error measure:
                % Either G < 1e-10 or %error < specified
                Gr = G(x, y, t, L, tr);
                if Gr > 1e-10
                    error = abs(P/Gr-1)/error_allowable_percent*...
                        error_allowable_linear;
                else
                    error = abs(P-Gr);
                end
                if ~(error < Inf)
                    current_error = 1000;
                    disp(['x' num2str(x) ' y' num2str(y) ' t' num2str(t)])
                end
                if error > current_error
                    current_error = error;
                end
            end
            if current_error > error_allowable_linear
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
title ('Lowest Chebyshev left-pivot c vs. x');
xlabel ('x');
ylabel ('y');
zlabel ('Minimum pivot c (time)');
% save 'test'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%