% Data set
S = S27;
set_size = 9;

% W-t plot for varying L, all else the same
for set = 1:3
    figure(set); clf;
    for i = 1:set_size
        index = i + (set-1)*set_size;
        
        t = S(index).t;
        W = S(index).W;
        
        plot(t,W,'Color',get_rainbow_colour(i,set_size));
        if i == 1
            hold on
        end
    end
    xlabel ('\itt','FontSize',24);
    ylabel ('\itW','FontSize', 24);
    legend({'L = 10',...
        'L = 20',...}
        'L = 40',...
        'L = 80',...
        'L = 120',...
        'L = 160',...
        'L = 200',...
        'L = 240',...
        'L = 320'},...
        'Location',...
        'EastOutside');
    %     disp(['tau_c = ' num2str(S(index).tauc)]);
end

% W-t plot for varying L, all else the same
for set = 1:3
    figure(set+10); clf;
    for i = 1:set_size
        index = i + (set-1)*set_size;
        
        lt = log10(S(index).t);
        lW = log10(S(index).W);
        
        plot(lt,lW,'Color',get_rainbow_colour(i,set_size));
        if i == 1
            hold on
        end
    end
    
    xlabel ('log_{10} \itt','FontSize',24);
    ylabel ('log_{10} \itW','FontSize', 24);
    legend({'L = 10',...
        'L = 20',...}
        'L = 40',...
        'L = 80',...
        'L = 120',...
        'L = 160',...
        'L = 200',...
        'L = 240',...
        'L = 320'},...
        'Location',...
        'EastOutside');
    
    %     disp(['tau_c = ' num2str(S(index).tauc)]);
end

% beta-L plot
for set = 1:3
    figure(set+20); clf;
    for i = 1:set_size
        index = i + (set-1)*set_size;
        
        L = S(index).L;
        beta = S(index).beta;
        
        plot(L,beta,'.',...
            'Color',get_rainbow_colour(i,set_size),...
            'MarkerSize', 24);
        if i == 1
            hold on
        end
    end
    
    xlabel ('\itL','FontSize',24);
    ylabel ('\it\beta','FontSize', 24);
    
    %     disp(['tau_c = ' num2str(S(index).tauc)]);
end