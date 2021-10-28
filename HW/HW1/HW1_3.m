%% Numerically solve system of equations:
%equation 1: x^2 + y^2 = 4
%equation 2: e^x +y = 1
%x1=x;
%x2=y
%solve system using Newton's Method:

e=1e-2; %FIX: changed from 1e5
xkm1=[1; 1];
xk=xkm1+2*e; %just to make sure we enter the first loop iteration
iterN=0; %fixed naming convention. Start with lower letters

fnF=@(x) [x(1)^2+x(2)^2-4 ;
        exp(x(1))+x(2)-1]; %fix from old code: turned + const to - const
fnJ=@(x) [2*x(1) 2*x(2);
        exp(x(1)) 1];

while norm(xk-xkm1,2)>e %Euclid norm
    xkm1=xk;
    F=fnF(xkm1);
    J=fnJ(xkm1);
    dx=-J\F; %FIX: changed from right divide to left divide. we need to solve J*dx=-F
    % dx=-inv(J)*F; same thing as the above, only fancier, and may not
    % involve inverses
    xk=xkm1+dx;
    
    iterN=iterN+1;
end

%print solution
fprintf('with interations = %g\n',iterN);
fprintf('xk=%g,%g\n',xk);
fprintf('F(xk)=%g,%g\n',F);
fprintf('F(xk)=%g,%g\n',F);

%% Plot solution against symbolic solution
syms x y
eq1=x^2+y^2==4;
eq2=exp(x)+y==1;
fig=figure('color',[1,1,1]);
ax=axes(fig);
hold(ax,'on'); grid(ax,'on');
fimplicit(ax,eq1);
fimplicit(ax,eq2);
scatter(ax,xk(1),xk(2),20,"black",'filled');