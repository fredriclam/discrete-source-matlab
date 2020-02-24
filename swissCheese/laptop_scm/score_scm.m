function [score, sites] = score_scm(N, A, L, r, ratio, mode)

score = 0;
for i = 1:N
    result = run_scm(A,L,r,ratio,mode);
    score = score + result;
    % Debug graphing
    if i == N
        [result, sites] = run_scm(A,L,r,ratio,mode);
    end
end
score = score/N;