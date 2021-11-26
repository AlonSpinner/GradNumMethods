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

ii = 1;
while ii <= length(t)-1
    yii = y(ii,:)';
    k0 = f(t(ii),yii);
    k1 = f(t(ii)+0.5*h,yii+(h/2)*k0);
    k2 = f(t(ii)+0.5*h,yii+(h/2)*k1);
    k3 = f(t(ii)+h,yii+h*k2);

    yiip1 = y(ii,:) + (h/6)*(k0+2*k1+2*k2+k3)'; %transpose for row vector
    
    %adaptive for wall
    if detectCollision(yiip1(1),yiip1(2))
        y = y(1:ii,:); t = t(1:ii,:); %cut shorter
        break;
    end
    p = funcbund.theta2p([yiip1(1),yiip1(2)]);
    if (p(1,1)-funcbund.wallX)<0 || (p(2,1)-funcbund.wallX)<0 %one of the xs is more negative than xWall
        h = h/2;
        continue
    end
    
    %if we didnt break or continue,
    y(ii+1,:) = yiip1;
    ii = ii+1;
end
end

function Q = detectCollision(th1,th2)
%quick and dirty defintions
xWall = funcbund.wallX;
tolx = funcbund.TolWallX;
Q=false;
p = funcbund.theta2p([th1,th2]);
if abs(p(1,1)-xWall)<tolx || abs(p(2,1)-xWall)<tolx
    Q=true;
end
end
