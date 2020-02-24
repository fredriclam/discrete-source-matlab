% import to solution
% grid isotherm
X_length = 2000;
Y_length = 30;
t = 176; % Snapshot at one instance of time
Z = zeros(X_length, Y_length);
for i = 1:X_length
    for j = 1:Y_length
        for p = 1:size(solution,1)
            if t > solution(p,4)
                Z(i,j) = Z(i,j) + Green1Image(...
                    i,...
                    j,...
                    t,...
                    solution(p,2),...
                    solution(p,3),...
                    solution(p,4),...
                    Y_length);
            else
                break
            end
        end
    end
end
        