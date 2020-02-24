% Sums the contribution of sources at x, y

function psum = particle_sum(x,y, fixed_particle, moving_particle, u, ...
    plus_sources, minus_sources)

k = 1;
psum = fixed_particle(x,y);
for i = 1:plus_sources
    psum = psum + moving_particle(x,y,u(k),u(k+1));
    k = k + 2;
end
for i = 1:minus_sources
    psum = psum - moving_particle(x,y,u(k),u(k+1));
    k = k + 2;
end