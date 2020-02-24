function Measurement_tauc(t, tr, file_name, lookup, dq, q_max)
% Front width measurement and animation

T_ign = 0.5;
dt = 5.0e-1;
plot_t = 0.5;
tol = 1e-8;
Dt = plot_t+tol;
% Cloud = dlmread('14_Mar_2016_Test_Cloud.dat','');
Cloud = dlmread(file_name,'',1,0);
Result = dlmread(file_name,'',1,0);
% Result = dlmread('Result_Mar14_Periodic_Mirror1_dt1e1.plt','',1,0);
N = 900;
L = 30.0;
I = 200;
Ni = 93;
Nmirror = 1;
% t = 1.0;

for i = Ni+1:N
    Cloud(i,:) = Result(i-Ni,:);
end

X = linspace(0,L,I);
Y = linspace(0,L,I);

tf = Cloud(N,4);
count = 1;

% while t<tf
% t = 9.0;
T = zeros(I,I);
count_f = 1;
for j = 1:I
    for i = 1:I
        Ind = 1;
        while (t-Cloud(Ind,4))>=0
            R2 = (X(i)-Cloud(Ind,2))^2+(Y(j)-Cloud(Ind,3))^2;
%             T(j,i) = T(j,i)+(1.0/(4.0*pi*(t-Cloud(Ind,4))))*exp(-R2/(4.0*(t-Cloud(Ind,4))));
            T(j,i) = T(j,i)+T_i_tr_boss(t-Cloud(Ind,4),R2, tr, lookup, dq, q_max);

            for mirror_i = 1:Nmirror
                R2 = (X(i)-Cloud(Ind,2))^2+(Y(j)-Cloud(Ind,3)+mirror_i*L)^2;
%                 T(j,i) = T(j,i)+(1.0/(4.0*pi*(t-Cloud(Ind,4))))*exp(-R2/(4.0*(t-Cloud(Ind,4))));
                T(j,i) = T(j,i)+T_i_tr_boss(t-Cloud(Ind,4),R2, tr, lookup, dq, q_max);
                R2 = (X(i)-Cloud(Ind,2))^2+(Y(j)-Cloud(Ind,3)-mirror_i*L)^2;
                T(j,i) = T(j,i)+T_i_tr_boss(t-Cloud(Ind,4),R2, tr, lookup, dq, q_max);
%                 T(j,i) = T(j,i)+(1.0/(4.0*pi*(t-Cloud(Ind,4))))*exp(-R2/(4.0*(t-Cloud(Ind,4))));
            end
            
            Ind = Ind+1;
        end
    end
    
    while T(j,i) < T_ign
        if i <= 1
            i = 1;
            break
        end
        i = i -1;
    end
    h(j,1) = X(i)+(X(i+1)-X(i))/(T(j,i+1)-T(j,i))*(T_ign-T(j,i));
    
end


%     Width(count,1) = t;
%     Width(count,2) = mean(h(:,1));
%     Width(count,3) = sqrt(mean((h-mean(h)).^2));
%     count = count+1;
%     t = t+dt;
%     clear h
% end
% contourf(X,Y,T,50,'LineColor','none');
figure (1)
hold all
contourf(X,Y,T,[0:0.008:1.8],'LineColor','none');
colormap('hot');
for i = 1:N
    if t>Cloud(i,4)
        plot(Cloud(i,2),Cloud(i,3),'o','MarkerFaceColor','black','MarkerEdgeColor','black','MarkerSize',4);
    else
        plot(Cloud(i,2),Cloud(i,3),'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[1 1 1],'MarkerSize',4);
    end
end
plot(h,Y,'Color','green','LineWidth',3);
pbaspect([1 1 1]);
caxis([0, 2]);


