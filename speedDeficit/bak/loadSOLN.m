function entry = loadSOLN(file_str)
N_STEPS = 1e2;
D = importdata(file_str);

% Check for blank file
if isempty(D)
    entry = [];
    return
end

str = D.textdata;
R = D.data;
entry.raw_data = R;

% Get parameters
pattern = '(?<name>\S+):\s+(?<val>\S+)';
J = regexp(str,pattern,'names');
parameters_struct = J{1};
for i = 1:length(parameters_struct)
    % Filter words only
    s = parameters_struct(i).name;
    s = s(regexp(s,'\w'));
    eval( ['entry.' s '=' ...
        parameters_struct(i).val ';']);
end
   
% Filter for corrupt data
R(R(:,1)>1e5,:) = [];

% Scan data for negatives to check if cylindrical or slab
if sum(sum(R < 0)) % No negatives; slab
    entry.geometry = 'cylinder';
else
    entry.geometry = 'slab';
end

% Max t scale
t_max = max(R(R(:,5)<1e8,5));
dt = t_max/N_STEPS;
t = dt;
x_vector = nan(1,N_STEPS);
t_vector = nan(1,N_STEPS);
for n = 1:N_STEPS
    x_max = max(R(R(:,5)<t,2));% Use this as front
    x_vector(n) = x_max;
    t_vector(n) = t;
    t = t + dt;
end

% Save to output struct
entry.x_vector = x_vector;
entry.t_vector = t_vector;

% Impromptu speed calculation on latter 50%
[X, Y] = prepareCurveData(t_vector(floor(0.5*length(x_vector)):end), ...
    x_vector(floor(0.5*length(x_vector)):end));
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares');
[fitresult, gof] = fit(...
    X, Y, ft, opts );
entry.speed = fitresult.p1;
entry.r2 = gof.rsquare;
entry.plot = @() plot(entry.t_vector, entry.x_vector);

% Check for propagation success/failure: "90% rule" in space
if max(R(R(:,5) < 1e8,2)) > 0.9 * max(R(:,2));
    entry.success = true;
else
    entry.success = false;
end
