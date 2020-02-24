dt = 1.1e-1;
t_vector = 0:dt:500; % Good range of simu-time
r2 = 1;
tr = 1;
N = length(t_vector);

% Init
standard = zeros(1,N);
test = standard;
% error = standard;

for i = 1:N
    t = t_vector(i);
    standard(i) = T_i_tr_exact(t, r2, tr);%/(4*pi*t);
    test(i) = T_i_tr_quad(t, r2, tr, lookup, dq, q_max);%/(4*pi*t);
end

error = abs(standard - test);

% Plot Green's function
figure(5);
plot(t_vector,standard,'r');
hold on;
plot(t_vector,test);

figure(6);
% Plot error
plot(t_vector, error);