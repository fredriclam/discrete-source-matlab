P = [];
NUM_SOLNS = 10;

for i = 1:length(saved_D)
    name = saved_D(i).name;
    cd(name);
    
    file_direc = dir('SOLN*');
    
    ratios = zeros(1,NUM_SOLNS);
    for j = 1:length(file_direc)
        N = importdata(file_direc(j).name);
        q = N.data;
        
        % Take 5th column
        tign = q(:,5);
        tign = tign < 1e8;
        ignited_count = sum(tign);
        ignition_ratio = ignited_count / size(q,1);
        
        ratios(j) = ignition_ratio;
    end
    
    % Reduce
    temp = ratios > 0.95;
    pp = sum(temp)/length(temp);
    
    P(i).ratios = ratios;
    P(i).name = name;
    P(i).pp = pp;
    
    cd ..;
end