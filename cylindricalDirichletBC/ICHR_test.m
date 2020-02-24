% Polyvalent testing: plots harmonics / temp. map

b = 20;

% Source location
r0 = 1;
th = 0;

z = 1;

% Range parameters
res_r = 10;
res_t = 11;
t_min = 0.1;
t_max = 1;

M = 4;
N = 5;

range_r = linspace(0,b,res_r);
range_t = linspace(t_min,t_max,res_t);

% Error factor
efactor = @(t) 1/pi^2/b^2 ...
    / sqrt(4*pi*t) ...
    * exp(-z.^2/4./t);

% Pre-allocate temp variable
Z = zeros(res_r, res_t);
Z_accepted = Z;
error_ss = zeros(M+1, N);
error_ai = zeros(M-1, N-2);

% Accepted solution
for i = 1:res_r
    r = range_r(i);
    for j = 1:res_t
        t = range_t(j);
        Z_accepted(i,j) = efactor(t)*ICHR_omega(r, r0, t, th, b, 10, 10);
    end
end

% Harmonics
figure(1); clf;
% Compute error for M, N
for m = 0:M
    for n = 1:N
        % Generate error over (r, t) domain
        subplot(M+1,N,m*N+n);
        for i = 1:res_r
            r = range_r(i);
            for j = 1:res_t
                t = range_t(j);
                Z(i,j) = efactor(t)*ICHR_omega(r, r0, t, th, b, m, n);
            end
        end
        % Simple sum error
        error_ss(m+1,n) = max(max(Z));
%         % Plot error plots
%         surf(range_t, range_r, Z-Z_accepted);
%         title(['m = ' num2str(m) ', n = ' num2str(n)]);
%         xlabel 't'
%         ylabel 'r'
    end
end

% Aitken Delta Harmonics
figure(2); clf;
for m = 0:M-2
    for n = 1:N-2
        subplot(M-1,N,m*N+n);
        for i = 1:res_r
            r = range_r(i);
            for j = 1:res_t
                t = range_t(j);
                x0 = ICHR_omega(r, r0, t, th, b, m, n);
                x1 = ICHR_omega(r, r0, t, th, b, m+1, n);
                x2 = ICHR_omega(r, r0, t, th, b, m+2, n);
                d0 = x1 - x0;
                d1 = x2 - x1;
                dd = d1 - d0;
                harmonic0 = x0 - d0.^2 / dd;

                x0 = ICHR_omega(r, r0, t, th, b, m, n+1);
                x1 = ICHR_omega(r, r0, t, th, b, m+1, n+1);
                x2 = ICHR_omega(r, r0, t, th, b, m+2, n+1);
                d0 = x1 - x0;
                d1 = x2 - x1;
                dd = d1 - d0;
                harmonic1 = x0 - d0.^2 / dd;

                x0 = ICHR_omega(r, r0, t, th, b, m, n+2);
                x1 = ICHR_omega(r, r0, t, th, b, m+1, n+2);
                x2 = ICHR_omega(r, r0, t, th, b, m+2, n+2);
                d0 = x1 - x0;
                d1 = x2 - x1;
                dd = d1 - d0;
                harmonic2 = x0 - d0.^2 / dd;

                d0 = harmonic1 - harmonic0;
                d1 = harmonic2 - harmonic1;
                dd = d1 - d0;

                Z(i,j) = harmonic0 - d0.^2./dd;
                Z(i,j) = efactor(t)* Z(i,j);
            end
        end
        
        % Accelerated method error
        error_ai(m+1,n) = max(max(Z));
%         % Plot error plots
%         surf(range_t, range_r, Z-Z_accepted);
%         title(['m = ' num2str(m) ', n = ' num2str(n)]);
%         xlabel 't'
%         ylabel 'r'
    end
end