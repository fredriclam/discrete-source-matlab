% Returns general Green's function G. Accepts vector y
function G = generalGreen(tauc,x,y,t)
r2 = meshgrid(x,y).^2+meshgrid(y,x)'.^2;
t = meshgrid(t,y);
% negativeFlag = false;
% 
% if t < 0
%     t = -t;
%     % Negative flag
%     negativeFlag = true;
% end
if t == 0
    G = 0;
    return
end

if t > tauc
    firstTerm = ei(-r2./(4*(t-tauc)));
else
    firstTerm = 0;
end
    
% Compute returned value
G = ( firstTerm - ei(-r2 ./ (4*t))) ...
    ./ (4*pi*tauc);
% if negativeFlag
%     G = -G;
% end
% 
% try
% assert(~sum(sum(isinf(G))));
% catch
%     1;
% end