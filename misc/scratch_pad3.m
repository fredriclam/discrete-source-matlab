%% Plot overdrive / "underdrive"
% figure(12);
% plot(R12(11).t,R12(11).W,'r'); hold on;
% plot(R12(12).t,R12(12).W,'b');
% plot(Q76(1).t,Q76(1).W,'g');
% 
% figure(13);
% loglog(R12(11).t,R12(11).W,'r'); hold on;
% loglog(R12(12).t,R12(12).W,'b');
% loglog(Q76(1).t,Q76(1).W,'g');

%% Flame speed comparison
for i = 1:length(Q)
    % Fit for continuum flame speed
    tign = Q(i).tign;
    tauc = Q(i).tauc;
    if Q(i).tauc ~= 0
        vf = flame_switch_speed(...
            tign,...
            tauc);
        Q(i).vf_cont = abs(vf);
    else
        Q(i).vf_cont = Inf;
    end
    
    % Fit for speed measurement
    ft = fittype( 'poly1' );
    opts = fitoptions( 'Method', 'LinearLeastSquares');
    [fitresult, gof] = fit(...
        Q(i).t, Q(i).x, ft, opts );
    % Get slope
    Q(i).vf = fitresult.p1;
    Q(i).vf_check = gof.rsquare;

    if Q(i).vf_cont == Inf
            Q(i).v_deficit = 1;
    else
        Q(i).v_deficit = ...
                (Q(i).vf_cont - Q(i).vf)/Q(i).vf_cont;
    end
end