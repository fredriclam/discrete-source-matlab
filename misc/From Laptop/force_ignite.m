function force_ignite(t, dt, data_table)
    for i = size(data_table,1)
        if abs(t - data_table(i,4)) < dt
            ignite(i);
        end
    end
end