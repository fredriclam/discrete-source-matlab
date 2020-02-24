A = 2;
dx = 0.5;
Pr_p = @(P1,dx) 1-exp(-A.*dx .* ( 1- P1) );

P_1_vector = linspace(0,1,100);
dx_range = dx;
plot_matrix = zeros(length(dx_range),length(P_1_vector));

for i = 1:length(dx_range)
    dx = dx_range(i);
    plot_matrix(i,:) = Pr_p(P_1_vector, dx);
end

plot(P_1_vector, plot_matrix);
legend('a')