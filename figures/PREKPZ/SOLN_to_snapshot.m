% Import SOLN into particle-highlighting snapshot

% * With figure open from TFLD_to_contour:
hold on
file_name_approx = 'SOLN258_*';
D = dir(file_name_approx);
file_name_soln = D(1).name;

% Import the data
S = importdata(file_name_soln);
S = S.data;

t = 8;

X_on = [];
Y_on = [];
X_off = [];
Y_off = [];

i = 1;
while i <= size(S,1)
    if S(i,4) < t
        X_on = [X_on S(i,2)];
        Y_on = [Y_on S(i,3)];
    else
        X_off = [X_off S(i,2)];
        Y_off = [Y_off S(i,3)];
    end
    i = i + 1;
end

% Replicator with L = 20
L = 20;
XX_on = [X_on X_on X_on];
YY_on = [Y_on Y_on+L Y_on+2*L];
XX_off = [X_off X_off X_off];
YY_off = [Y_off Y_off+L Y_off+2*L];

% Plot
hold on
% plot(XX_on,YY_on,'.k');
% plot(XX_off,YY_off,'.w');