function [T_mat] = rod_implicit(dx,dt,time)
Ta = 0.5;
hc = 1;
k = 1;
lambda = k * dt/ (dx^2);
L_var = (dx+hc*dt+k*dt/dx);
R_var = (dx+k*dt/(dx));

F_TL = @(v_l_1,v_l_2,v1,v2,T_t) ((Ta*hc + ((v1-v_l_1)*dt - (v2-v_l_2)*dt)*dx) * dt + T_t*dx);
F_TR = @(v_l_1,v_l_2,v1,v2,T_t) ((((v1-v_l_1)*dt - (v2-v_l_2)*dt)*dx -1)*dt + T_t * dx);


T_mat = zeros(time/dt+1,1/dx+1);
B_mat = diag(ones(1/dx,1),1)*(-lambda)+diag(ones(1/dx+1,1))*(1+2*lambda)+diag(ones(1/dx,1),-1)*(-lambda);
B_mat(1,1) = L_var; B_mat(1,2) = -k*dt/dx;
B_mat(end,end) = R_var; B_mat(end,end-1) = -k*dt/dx;

v = zeros(1/dx+1,1);
v_l = v;
b_vec = v;
for i = 2:time/dt+1
    for j = 0:1/dx
        v(j+1) = HW4_2_v(j*dx,i*dt);
        if (j ~= 0 && j ~= 1/dx)
        b_vec(j+1) = T_mat(i-1,j+1) + v(j+1)*dt;
        end
    end
b_vec(1) = F_TL(v_l(1),v_l(2),v(1),v(2),T_mat(i-1,1));
b_vec(end) = F_TR(v_l(end-1),v_l(end),v(end-1),v(end),T_mat(i-1,end));
T_mat(i,:) = (B_mat\b_vec);

v_l = v;

end
end