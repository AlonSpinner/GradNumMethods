%% Q2 
syms x y
f = x^2 + x*cos(y);
df = [diff(f,x),diff(f,y)];
H = [diff(f,x,2), diff(diff(f,x),y)
    diff(diff(f,x),y), diff(f,y,2)];
x0 = [1,1];
s0 = double(subs(-df,[x,y],x0))';
H0 = double(subs(H,[x,y],x0));
lambda0 = s0'*s0/(s0'*H0*s0);
x1 = x0+s0'*lambda0;

disp(double(subs(f,[x,y],x0)));
disp(double(subs(f,[x,y],x1)));