clc;
x=[1; 1];
x_prev=x;
e=1e5;
IterN=0;

while norm(x-x_prev)>e
    x_prev=x;
    F=[x(1)^2+x(2)^2+4  exp(x(1))+x(2)+1];
    J=[2*x(1) 2*x(2);
        exp(x(1)) 1];
    dx=-J/F;
    x=x+dx;
    IterN=IterN+1
end
