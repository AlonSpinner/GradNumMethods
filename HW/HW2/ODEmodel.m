function [A,b]=ODEmodel(n)
a=1; c=2; ya=1; yb=2;
h=(c-a)/(n+1);
x=a:h:c;
A=zeros(n); b=zeros(n,1);

A(1,1:2)=[2+h^2*2      -1+h/2*1];
b(1)=-h^2*r(x(2),a,c)+(1+h/2*1)*ya;

for i=2:n-1
    A(i,i-1:i+1)=[-1-h/2*1      2+h^2*2       -1+h/2*1];
    b(i)=-h^2*r(x(i+1),a,c);
end

A(n,n-1:n)=[-1-h/2*1      2+h^2*2];
b(n)=-h^2*r(x(n),a,c)+(1-h/2*1)*yb;

function y=r(x,a,c)
d=c-a;
if a<x && x<a+0.2*d
    y=0;
elseif x<a+0.4*d
    y=-3-x;
elseif x<a+0.6*d
    y=0;
elseif x<a+0.8*d
    y=-7-x;
else
    y=0;
end