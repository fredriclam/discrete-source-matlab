% WIP: stretch all things to stack on top of each other and so on

% x-Normalized average
[x, y] = extract_average;
logx = log(x);
logy = log(y);

% Get lowest value of x
x_min = 1.8;
low_x = -1337;
i_low = 0;
i = 1;
while i <= length(logx)
    if logx(i) > x_min
        low_x = logx(i);
        i_low = i;
        break;
    end
    i = i + 1;
end
assert(low_x ~= -1337 && i_low ~= 0);

% High index
high_x = logx(length(logx));

% Slice data vector
x_output = logx(i_low:length(logx));
y_output = logy(i_low:length(logx));

% Scale x only; slope is not preserved
x_output = 

value_low