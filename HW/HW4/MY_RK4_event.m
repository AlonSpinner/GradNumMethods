function [t,y] = MY_RK4_event(fun_handle, step_size, time_span, initial_value)
h = step_size; %shorter notation
t=[time_span(1):h:time_span(2)]';

initial_value = initial_value(:)'; %ensure it is a row vector
y = zeros(length(t),length(initial_value));
y(1,:) = initial_value;

if isstring(fun_handle) || ischar(fun_handle)
    f = str2func(fun_handle);
else
    f = fun_handle;
end

for ii = 1:length(t)-1
    yii = y(ii,:)';
    k0 = f(t(ii),yii);
    k1 = f(t(ii)+0.5*h,yii+(h/2)*k0);
    k2 = f(t(ii)+0.5*h,yii+(h/2)*k1);
    k3 = f(t(ii)+h,yii+h*k2);

    yiip1 = y(ii,:) + (h/6)*(k0+2*k1+2*k2+k3)'; %transpose for row vector
    if detectCollision(yiip1(1),yiip1(2)), break, end
    
    [x1,x2] = theta2x(yiip1(1),yiip1(2));
    if (x1-xWall)<0 || abs(x2-xWall)<0 %one of the xs is more negative than xWall
        
    end

    y(ii+1,:) = y(ii,:) + (h/6)*(k0+2*k1+2*k2+k3)'; %transpose for row vector
end
end

function Q = detectCollision(th1,th2)
%quick and dirty defintions
xWall = -0.5;
tolx = 1e-8;

[x1,x2] = theta2x(th1,th2);
if abs(x1-xWall)<tolx || abs(x2-xWall)<tolx
    Q=true;
else
    Q=false;
end
end

function [x1,x2] = theta2x(th1,th2)
%quick and dirty defintions
l1 = 1; l2 = 2;
%compute
x1 = l1*cos(th1-pi/2); %-pi/2 for coordiante system
x2 = x1 + l2*cos(th2-pi/2);
end

function biSect
    
end