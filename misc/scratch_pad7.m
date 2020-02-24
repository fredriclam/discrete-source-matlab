for i = 48:55
    str = ['fm = fittedmodel' num2str(i) ';'];
    eval(str);
    item.fm = fm;
    item.beta = fm.p1;

    str = ['r2 = goodness' num2str(i) '.rsquare;'];
    eval(str);
    item.r2 = r2;
    
    item.ci = confint(fm,0.95);
    ITEMS(i) = item;
end

for i = 1:47
    SQ(i).fitted_model = S47w_manual_trim(i).fm;
    SQ(i).beta_trim = S47w_manual_trim(i).beta;
    SQ(i).r2_trim = S47w_manual_trim(i).r2;
    SQ(i).ci_trim = S47w_manual_trim(i).ci;
end