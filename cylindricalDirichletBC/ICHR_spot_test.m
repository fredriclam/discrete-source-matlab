% b = 20;
b = 9;
r = 4.102564102564102;
r0 = 6.150769230769231;
t = 0.1;
z = 0;
th = 0.997597901025655;

% Test indices
M = 90;
N = 90;
m = 45;
n = 45;

% Cache table
% alpha = ICHR_construct_alpha(M,N);

% Sum
S = @(m) ICHR_omega(r,r0,t,th,b,m,n,alpha);

% term
a = @(m) ICHR_term(r,r0,t,th,b,m,n,alpha);

% Levin u-transform
% num = 0;
% den = 0;
% beta = 1;
% for j = 0:m
%     num = num + ...
%         (-1)^j * nchoosek(m,j) * ((j+1+beta)/(m+1+beta))^(m-1) * ...
%         S(j) / ((j+beta)*a(j));
%     den = den + ...
%         (-1)^j * nchoosek(m,j) * ((j+1+beta)/(m+1+beta))^(m-1) * ...
%         1 / ((j+beta)*a(j));

% end
% result = num./den;
% Aitken delta
% x0 = S(m-2);
% x1 = S(m-1);
% x2 = S(m);
% d1 = x2 - x1;
% d0 = x1 - x0;
% dd = d1 - d0;
% result = x0 - d0.^2/dd;
% result = 1/pi^2/b^2 * result;

clc
% disp(['Aitken:      ' num2str(result)]);
% disp(ICHR_omega(r,r0,t,th,b,5,5,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,5,5,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,10,10,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,15,15,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,20,20,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,25,25,alpha));
% disp(ICHR_polar(r,r0,t,th,z,b,30,30,alpha));
n2 = (r*cos(th)-r)^2 + (r*sin(th))^2 + z^2;
G = 1/(4*pi*t)^(3/2)*exp(-n2/(4*t));
disp(['Open Greens: ' num2str(G)]);
disp(['5:           ' num2str(ICHR_polar(r,r0,t,th,z,b,5,5,alpha))]);
disp(['30:          ' num2str(ICHR_polar(r,r0,t,th,z,b,30,30,alpha))]);
disp(['45:          ' num2str(ICHR_polar(r,r0,t,th,z,b,45,45,alpha))]);
disp(['K45:         ' num2str(ICHR_K(r,r0,t,th,z,b,45,45,alpha))]);
disp(['80:          ' num2str(ICHR_polar(r,r0,t,th,z,b,80,80,alpha))]);
disp(['90:          ' num2str(ICHR_polar(r,r0,t,th,z,b,90,90,alpha))]);
disp(['K90:         ' num2str(ICHR_K(r,r0,t,th,z,b,90,90,alpha))]);


% disp(['K5:         ' num2str(ICHR_K(r,r0,t,th,z,b,45,45,alpha,5))]);
% disp(['K25:         ' num2str(ICHR_K(r,r0,t,th,z,b,45,45,alpha,25))]);
% disp(['K45:         ' num2str(ICHR_K(r,r0,t,th,z,b,45,45,alpha,45))]);

t_range = logspace(-1,log10(3),40);
G_range = t_range;
for i = 1:length(t_range)
    t = t_range(i);
    ICHR_range45(i) = ICHR_polar(r,r0,t,th,z,b,45,45,alpha);
    ICHR_range10(i) = ICHR_polar(r,r0,t,th,z,b,10,10,alpha);
    ICHR_range10K(i) = ICHR_K(r,r0,t,th,z,b,10,10,alpha);
    ICHR_range20(i) = ICHR_polar(r,r0,t,th,z,b,20,20,alpha);
    ICHR_range20K(i) = ICHR_K(r,r0,t,th,z,b,20,20,alpha);
    ICHR_20IPR(i) = ICHR_IPR(r,r0,t,th,z,b,20,10,alpha);
    ICHR_10IPR(i) = ICHR_IPR(r,r0,t,th,z,b,10,10,alpha);
    ICHR_5IPR(i) = ICHR_IPR(r,r0,t,th,z,b,20,8,alpha);
    G_range(i) = 1/(4*pi*t)^(3/2)*exp(-n2/(4*t));
end

% Get difference
% ICHR_range5 = G_range - ICHR_range5;
% ICHR_range20 = G_range - ICHR_range20;
% ICHR_range45 = G_range - ICHR_range45;
% ICHR_range80 = G_range - ICHR_range80;


% Reference plot
figure(1); clf;
% plot(t_range,[G_range;ICHR_range45;ICHR_range10;ICHR_range10K;ICHR_range20;ICHR_range20K]);
plot(t_range,[G_range;ICHR_range45;ICHR_range10;ICHR_range10K;ICHR_range20;ICHR_20IPR;ICHR_10IPR;ICHR_5IPR]);
