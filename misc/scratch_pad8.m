% Derived from scratch_pad6
% Takes manually trimmed (removal of initial transient)
% beta-L data for different tau_c and plots with error
% bars

% Plot
figure(1335); clf;

% Work vector Q
clear Q
S = S60_trim;
Q{1} = S(1:12); % <----
Q{2} = S(13:24); % <----
Q{3} = S(25:36); % <----
Q{4} = S(37:48); % <----
Q{5} = S(49:end);
cases = 5;

for i = 1:cases
    x = [Q{i}.L];
    % Check if beta_naive is empty
    y = [Q{i}.beta_trim];
    if isempty(y)
        y = [Q{i}.beta_naive];
        neg = y - [Q{i}.ci_low];
        pos = [Q{i}.ci_high] - y;
    else
        temp = {Q{i}.ci_trim};
        ci_low = [];
        ci_high = [];
        for j = 1:length(temp)
            CI = temp{j};
            ci_low(j) = CI(1,1);
            ci_high(j) = CI(2,1);
        end
        neg = y - ci_low;
        pos = ci_high - y;
    end
    % Plot
    errorbar(x, y, neg, pos,...
        'Color', get_rainbow_colour(i,cases));
    legend({'0', '0.1', '1', '10', '100'});
    if i == 1
        hold on
    end
end
xlabel 'L'
ylabel '\beta'