function [my_det,my_inv] = my_det_and_inv(input_mat)
n = funcbund.checkSquared(input_mat);
[L,U,P] = lu(input_mat);
P=P'; %Matlab returns P' instead of P for some reason
% A = PLU


% detP  = (-1)^t when t is the number of row switches
t=0;
tmpP = P;
for ii=1:n
    if tmpP(ii)==0
        [~,jj] = max(tmpP(ii,:));
        vTemp = tmpP(ii,:);
        tmpP(ii,:) = tmpP(jj,:);
        tmpP(jj,:) = vTemp;

        t = t+1;
    end
end
detP = (-1)^t;

my_det = prod(diag(U)) *detP; %L is promised to be with 1s in diagonal, doolittle
my_inv = funcbund.InverseU(U) * funcbund.InverseL(L) *P'; %inv(P) = P'
end

