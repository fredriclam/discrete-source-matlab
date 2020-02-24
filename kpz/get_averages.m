% Script to go through every directory without '@' in its name and run
% extract_average_v2 to extract t, x, N, W vectors. 

if strcmp(cd, 'c:\users\fredric\desktop') || ...
    strcmp(cd, 'c:\users\fredric\documents\matlab')
    error('You''re on your desktop or in MATLAB!!')
end

% Filter directories
D = dir;
i = 1;
while i <= length(D)
    if ~(D(i).isdir && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..') ...
        && isempty(regexp(D(i).name,'@', 'once')))
        D(i) = [];
    else
        i = i + 1;
    end
end

for i = 1:length(D)
    % Jump in folder
    cd (D(i).name)
    % Code
        % Take all data, only after 20 particles
        [t, x, N, W] = extract_average_v2(-1,20);
        all_data(i).name = D(i).name;
        all_data(i).t = t;
        all_data(i).x = x;
        all_data(i).N = N;
        all_data(i).W = W;
        
        % Take <range(h)> data
        all_data(i).flt = flthickness_average;
    % Jump out of folder
    cd ..
    disp(i);
end

% Extract TAUC, TIGN from name
for i = 1:length(all_data)
    name = all_data(i).name;
    % Translate TAUC code
    tauc_code = lower(name(1:length(name)-4));
    if regexp(tauc_code,'t','once')
        all_data(i).tauc = 0;
    else
        tauc = 0;
        for j = 1:length(tauc_code)
            % Read from right to left
            current_char = tauc_code(length(tauc_code)+1-j);
            % Translate current character (assume lower case)
            digit = mod(current_char - 96, 10);
            tauc = tauc + power(10,j-2)*digit;
        end
        all_data(i).tauc = tauc;
    end
    % Translate TIGN code
    four_digit_number = name(length(name)-3:length(name()));
    all_data(i).tign = str2double(four_digit_number) / 1000;
end

% Get overall beta (slope of logW-logt)
for i = 1:length(all_data)
    [X, Y] = prepareCurveData(log(all_data(i).t), log(all_data(i).W));
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    % (Don't) use robust fitting
    %         opts.Robust = 'Bisquare';
    % Fit model to data.
    [fitresult, gof] = fit(...
        X, Y, ft, opts );
    % Get slope
    all_data(i).beta = fitresult.p1;
end

% % Regenerate all spectrum plots
% for i = 1:length(all_data)
%     fn = @() deal(all_data(i).t, [], [], all_data(i).W);
%     slope_window_spectrum(fn);
%     savefig(all_data(i).name);
% end