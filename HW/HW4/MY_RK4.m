function [t,y] = MY_RK4(fun_handle, step_size, time_span, initial_value)
f = fun_handle;
h = step_size; %shorter notation
t=[time_span(1):h:time_span(2)]';

initial_value = initial_value(:)'; %ensure it is a row vector
y = zeros(length(t),length(initial_value));
y(1,:) = initial_value;

for ii = 1:length(t)-1
    yii = y(ii,:)';
    k0 = f(t(ii),yii);
    k1 = f(t(ii)+0.5*h,yii+0.5*h*k0);
    k2 = f(t(ii)+0.5*h,yii+0.5*h*k1);
    k3 = f(t(ii)+h,yii+h*k2);

    y(ii+1,:) = y(ii,:) + (h/6)*(k0+2*k1+2*k2+k3)'; %transpose for row vector
end