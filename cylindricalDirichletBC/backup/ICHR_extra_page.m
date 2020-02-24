t_range = logspace(-2,-1,40);

for i = 1:length(t_range)
    t = t_range(i);
    ICHR_range5X(i) = ICHR_polar(r,r0,t,th,z,b,5,5,alpha);
    ICHR_range45X(i) = ICHR_polar(r,r0,t,th,z,b,45,45,alpha);
    ICHR_range80X(i) = ICHR_polar(r,r0,t,th,z,b,80,80,alpha);
    ICHR_range90X(i) = ICHR_polar(r,r0,t,th,z,b,90,90,alpha);
    G_range(i) = 1/(4*pi*t)^(3/2)*exp(-n2/(4*t));
    correction_range(i) = G_range(i) - ICHR_range5X(i);
end

plot(t_range,[
    ICHR_range5X
    ICHR_range45X
    ICHR_range80X
    ICHR_range90X
    ]);