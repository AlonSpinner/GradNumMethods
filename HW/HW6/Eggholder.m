function Z = Eggholder(x,y)
% Eggholder function
Z = -(y+10).*sin(sqrt(abs(x/2+(y+10))))-x.*sin(sqrt(abs(x-(y+10))));