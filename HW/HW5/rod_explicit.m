function [T_mat] = rod_explicit(dx,dt,time)
Ta = 0.5;
hc = 1;
k = 1;
lambda = k * dt/ (dx^2);
L_var = (dx+hc*dt+k*dt/dx);
R_var = (dx+k*dt/(dx));
F_TL = @(v_l_1,v_l_2,v1,v2,T_t,T_x) ((Ta*hc + T_x * k/dx + ((v1-v_l_1)*dt - (v2-v_l_2)*dt)*dx) * dt + T_t*dx)/L_var;
F_TR = @(v_l_1,v_l_2,v1,v2,T_t,T_x) ((k/(dx) * T_x + ((v1-v_l_1)*dt - (v2-v_l_2)*dt)*dx -1)*dt + T_t*dx)/R_var;

T_mat = zeros(time/dt+1,1/dx + 1);
B_mat = diag(ones(1/dx,1),1)+diag(ones(1/dx + 1,1))*-2+diag(ones(1/dx ,1),-1);
B_mat = B_mat(:,2:end-1);
v = zeros(1/dx+1,1);
v_l = v;
for i = 2:time/dt+1
    for j = 0:1/dx
        v(j+1) = HW4_2_v(j*dx,i*dt);
    end
    T_mat(i,2:end-1) = T_mat(i-1,2:end-1) + lambda * T_mat(i-1,1:end)*B_mat + dt*v(2:end-1)';
    T_mat(i,1) = F_TL(v_l(1),v_l(2),v(1),v(2),T_mat(i-1,1),T_mat(i,2));
    T_mat(i,end) = F_TR(v_l(end-1),v_l(end),v(end-1),v(end),T_mat(i-1,end),T_mat(i,end-1));
    v_l = v;
end



end