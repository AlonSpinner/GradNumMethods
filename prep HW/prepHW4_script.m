f = @(t,y) (2/t)*y+(t^2)*exp(t);
h=0.1;
%% Euler
y=0;
t=1;
for ii=1:10
    y = y+h*f(t,y);
    t = t+h;
    disp(y)
end

%% RK2 with c=0.5
y=0;
t=1;
c=0.5;
alpha0 = 1-c;
alpha1 = 1-alpha0;
lambda = 1/(2*c);
beta = 1/(2*c);
for ii=1:10
    k0 = h*f(t,y);
    k1 = h*f(t+lambda*h,y+beta*k0);
    y = y + alpha0*k0 + alpha1*k1;
    t = t+h;
    disp(y)
end