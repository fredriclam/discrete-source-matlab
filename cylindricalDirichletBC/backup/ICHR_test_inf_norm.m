b = 20;

% Range parameters
res_r = 40;
res_t = 6;
res_z = 3;
res_th = 8;
t_min = 0.01;
t_max = 1;
z_max = 1;

range_r = linspace(0,b-0.01,res_r);
range_r0 = linspace(0,b-0.02,res_r);
range_t = linspace(t_min,t_max,res_t);
range_z = linspace(0,z_max,res_z);
range_th = linspace(0,pi,res_th)+1/10;

% Range of M, N to test
M = 3;
N = 4;

% Error factor
efactor = @(z,t) 1/pi^2/b^2 ...
    / sqrt(4*pi*t) ...
    * exp(-z.^2/4./t);

% Pre-allocate temp variable
Z = zeros(res_r, res_r, res_t, res_z, res_th);
Z_accepted = zeros(res_r, res_r, res_t, res_z, res_th);
error_ss = zeros(M+1, N);
error_ai = zeros(M-1, N-2);

% Accepted solution
for i1 = 1:res_r
    for i2 = 1:res_r
        for i3 = 1:res_t
            for i4 = 1:res_z
                for i5 = 1:res_th
                    r = range_r(i1);
                    r0 = range_r0(i2);
                    t = range_t(i3);
                    z = range_z(i4);
                    th = range_th(i5);
                        Z_accepted(i1,i2,i3,i4,i5) = efactor(z,t)*...
                            ICHR_omega(r, r0, t, th, b, 12, 12);
                end
            end
        end
    end
end

% Simple sum
for m = 0:M
    for n = 1:N
        for i1 = 1:res_r
            for i2 = 1:res_r
                for i3 = 1:res_t
                    for i4 = 1:res_z
                        for i5 = 1:res_th
                            r = range_r(i1);
                            r0 = range_r0(i2);
                            t = range_t(i3);
                            z = range_z(i4);
                            th = range_th(i5);
                            Z(i1,i2,i3,i4,i5) = abs(efactor(z,t)*...
                                ICHR_omega(r, r0, t, th, b, m, n) - ...
                                Z_accepted(i1,i2,i3,i4,i5));
                        end
                    end
                end
            end
        end
        % Simple sum error
        error_ss(m+1,n) = max(max(max(max(max(Z)))));
    end
end

% Aitken delta
for m = 0:M-2
    for n = 1:N
        for i1 = 1:res_r
            for i2 = 1:res_r
                for i3 = 1:res_t
                    for i4 = 1:res_z
                        for i5 = 1:res_th
                            r = range_r(i1);
                            r0 = range_r0(i2);
                            t = range_t(i3);
                            z = range_z(i4);
                            th = range_th(i5);
                            
                            % 2-D Aitken
%                             x0 = ICHR_omega(r, r0, t, th, b, m, n);
%                             x1 = ICHR_omega(r, r0, t, th, b, m+1, n);
%                             x2 = ICHR_omega(r, r0, t, th, b, m+2, n);
%                             d0 = x1 - x0;
%                             d1 = x2 - x1;
%                             dd = d1 - d0;
%                             if dd == 0
%                                 harmonic0 = x2;
%                             else
%                                 harmonic0 = x0 - d0.^2 / dd;
%                             end
%                             
%                             x0 = ICHR_omega(r, r0, t, th, b, m, n+1);
%                             x1 = ICHR_omega(r, r0, t, th, b, m+1, n+1);
%                             x2 = ICHR_omega(r, r0, t, th, b, m+2, n+1);
%                             d0 = x1 - x0;
%                             d1 = x2 - x1;
%                             dd = d1 - d0;
%                             if dd == 0
%                                 harmonic1 = x2;
%                             else
%                                 harmonic1 = x0 - d0.^2 / dd;
%                             end
%                             
%                             x0 = ICHR_omega(r, r0, t, th, b, m, n+2);
%                             x1 = ICHR_omega(r, r0, t, th, b, m+1, n+2);
%                             x2 = ICHR_omega(r, r0, t, th, b, m+2, n+2);
%                             d0 = x1 - x0;
%                             d1 = x2 - x1;
%                             dd = d1 - d0;
%                             if dd == 0
%                                 harmonic2 = x2;
%                             else
%                                 harmonic2 = x0 - d0.^2 / dd;
%                             end
%                             
%                             x0 = harmonic0;
%                             x1 = harmonic1;
%                             x2 = harmonic2;
%                             d0 = x1 - x0;
%                             d1 = x2 - x1;
%                             dd = d1 - d0;
%                             if dd == 0
%                                 harmonic = x2;
%                             else
%                                 harmonic = x0 - d0.^2 / dd;
%                             end

%                             % 1-D Aitken
%                             x0 = ICHR_omega(r, r0, t, th, b, m, n);
%                             x1 = ICHR_omega(r, r0, t, th, b, m+1, n);
%                             x2 = ICHR_omega(r, r0, t, th, b, m+2, n);
%                             d0 = x1 - x0;
%                             d1 = x2 - x1;
%                             dd = d1 - d0;
%                             if dd == 0
%                                 harmonic = x2;
%                             else
%                                 harmonic = x0 - d0.^2 / dd;
%                             end

                           
                        end
                    end
                end
            end
        end
        % Simple sum error
        error_ai(m+1,n) = max(max(max(max(max(Z)))));
    end
end