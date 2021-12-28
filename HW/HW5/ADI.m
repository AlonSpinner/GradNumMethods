function T_mat = ADI(dx,dy,dt,time,length)
lambda = 1/6;
T_mat = zeros((length/dx)+1,(length/dy)+1,(time/dt+1));

R_mat =  lambda * diag(ones(length/dx,1),1) + 2*(1-lambda) * diag(ones(length/dx+1,1)) + lambda * diag(ones(length/dx,1),-1);
R_mat_initial = 2*(1-lambda) * diag(ones(length/dx+1,1)) + 2 * lambda * diag(ones(length/dx,1),1);
L_mat = -lambda * diag(ones(length/dx,1),1) + 2*(1+lambda) * diag(ones(length/dx+1,1)) - lambda * diag(ones(length/dx,1),-1);
Temporal_T = zeros((length/dx)+1,(length/dy)+1);
b_vec = zeros(length/dx+1,1);
for i = 2:time/dt+1
    for j = 0:length/dx
        if (j==length/dx)
            Temporal_T(:,j+1) = 2-(0:length/dy)'*dy
        else
            if (j == 0)
                b_vec   = R_mat_initial * T_mat(:,j+1,i-1)+dt*fval(j*dx,(0:length/dy)'*dy).*T_mat(:,j+1,i-1);
            else
                b_vec =  R_mat * T_mat(:,j+1,i-1)+dt*fval(j*dx,(0:length/dy)'*dy).*T_mat(:,j+1,i-1);
            end

            Temporal_T(:,j+1) = L_mat\b_vec;
            Temporal_T(end,j+1) = 1;
        end
    end
    for j = 0:length/dy
        if (j == 0)
            T_mat(j+1,:,i) = ((0:length/dx)*dx)'.*(2-(0:length/dx)'*dx);
        elseif(j==length/dy)
            T_mat(j+1,:,i) = 1;
        else
            b_vec =  R_mat * Temporal_T(:,j+1)+dt*fval((0:length/dx)'*dx,j*dy).*Temporal_T(j+1,:)';
            T_mat(j+1,:,i) = L_mat\b_vec;
                
    end
    end
end




end