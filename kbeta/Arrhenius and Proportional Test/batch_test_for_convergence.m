dt_test = logspace(-3,-2,10);
e_l2_test = nan(size(dt_test));

for i = 1:length(dt_test)
    result = arrhenius_convolution_Temperature_only (dt_test(i));
    e_l2_test(i) = sqrt(sum((result(:,end)-ref).^2));
end

%%
figure
loglog(dt_test, e_l2_test,'.'); hold on
plot([1e-3,1e-2],1e3*[1e-3,1e-2],':')
plot([1e-3,1e-2],1e1*[1e-3,1e-2].^0.5,':')