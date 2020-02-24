test_t = 10:20:200;
x = cell(1);
y = cell(1);
for i = length(test_t)
    t = test_t(i);
    [x1, y1] = front_spectrum(t);
    x{i} = x1;
    y{i} = y1;
end