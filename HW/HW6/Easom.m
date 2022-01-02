function Z = Easom(x,y)
% Easom function
Z = -cos(x).*cos(y).*exp(-((x-pi).^2+(y-pi).^2));