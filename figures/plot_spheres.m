function plot_spheres(sites,r)
figure(11);
clf;
for i = 1:length(sites)
    x = sites(1,i);
    y = sites(2,i);
    z = sites(3,i);
    plot_sphere(x,y,z,r);
    if i == 1
        hold on
    end
end

function plot_sphere(u,v,w,r)
[x,y,z] = sphere;
x = x*r + u;
y = y*r + v;
z = z*r + w;
surf(x,y,z);