function T_mat = ADI(dx,dy,dt,time,length)
lambda = 1/6;
T_mat = zeros((length/dx)+1,(length/dy)+1,(round(time/dt+1)));

L_mat = -lambda * diag(ones(length/dx,1),1) + 2*(1+lambda) * diag(ones(length/dx+1,1)) - lambda * diag(ones(length/dx,1),-1);

L_mat_R = L_mat;
L_mat_R(1,1) = 2*(1+lambda);
L_mat_R(1,2) = -2*lambda;

T_mat(1,:,1) = (0:length/dx)'*dx.*(2-(0:length/dx)'*dx);
T_mat(end,:,1) = 1;
T_mat(:,end,1) = (2-(0:length/dx)'*dy);

Temporal_T = zeros((length/dx)+1,(length/dy)+1);
b_vec_s = zeros(size(T_mat,1),1);
lambda_vec = b_vec_s;
for i = 2:round(time/dt)+1
    for j = 0:length/dx-1
            if (j == 0)
                lambda_vec(1:2) = [2*(1-lambda);2*lambda];
            else
                lambda_vec(j:j+2) = [lambda;2*(1-lambda);lambda];
                if(j>1)
                lambda_vec(j-1) = 0;
                end
            end
            b_vec_s = T_mat(:,:,i-1)*lambda_vec + dt*fval(j*dx,(0:length/dy)'*dy).*T_mat(:,j+1,i-1);
            b_vec_s(1) = T_mat(1,j+1,i-1);
            b_vec_s(end) = T_mat(end,j+1,i-1);
            Temporal_T(:,j+1) = L_mat\b_vec_s;
            Temporal_T(end,j+1) = T_mat(end,j+1,i-1);
            Temporal_T(1,j+1) = T_mat(1,j+1,i-1);
             
    end
    Temporal_T(1,:) = (0:length/dx)'*dx.*(2-(0:length/dx)'*dx);
    Temporal_T(end,:) = 1;
    Temporal_T(:,end) = (2-(0:length/dx)'*dy);
    
    lambda_vec(end-2:end) = [0;0;0];
    for j = 0:length/dy-1
            if (j==0)
                lambda_vec(1:2) = [2*(1-lambda);lambda];
            else
                lambda_vec(j:j+2) = [lambda;2*(1-lambda);lambda];
                if(j>1)
                    lambda_vec(j-1) = 0;
                end
            end
            b_vec_s = Temporal_T'*lambda_vec + dt*fval((0:length/dx)'*dx,j*dy).*Temporal_T(j+1,:)';
            T_mat(j+1,:,i) = (L_mat_R\b_vec_s)';
    end
    T_mat(1,:,i) =  T_mat(1,:,i-1);
    T_mat(end,:,i) = T_mat(end,:,i-1);
    T_mat(:,end,i) =  T_mat(:,end,i-1);
end




end