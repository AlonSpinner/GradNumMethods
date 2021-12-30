

dt = 0.01
dx = 0.2
T2 = rod_explicit(dx,dt,20);


[X,Y] = meshgrid(0:0.1:1,0:0.01:20-0.01);  
surf(X,Y,T2)
ylabel('$$Time$$','interpreter','latex');
xlabel('$$location$$','interpreter','latex');
shading interp
colormap('hot');
colorbar;

%%
dt = 0.01
dx = 0.2
T2 = rod_CN(dx,dt,20);


[X,Y] = meshgrid(0:dx:1,0:dt:20-0.01);  
surf(X,Y,T2)
ylabel('$$Time$$','interpreter','latex');
xlabel('$$location$$','interpreter','latex');
shading interp
colormap('hot');
colorbar;
%%
dx = 0.1
length = 2
dt = 1/6*(0.1^2)/2;
time = 5;
T = ADI(dx,dx,dt,time,length);
[X,Y] = meshgrid(0:dx:length,0:dx:length);
%%
f_norm = norm(T(:,:,1))
max_i = 1
for i = 2:time/dt+1
    if (abs(f_norm-norm(T(:,:,i))) < 0.00001)
        max_i = i
        break
    end
    f_norm = norm(T(:,:,i));

end
%%
vec = [1:round(max_i/5):max_i,max_i];
for i = vec
figure(i)
surf(X,Y,T(:,:,i));
shading interp
colormap('hot');
colorbar;
title("Heat map at " + string(i*dt))
view(2)
end
