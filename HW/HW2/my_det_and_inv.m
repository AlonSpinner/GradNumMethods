function [my_det,my_inv] = my_det_and_inv(input_mat)
n = funcbund.checkSquared(input_mat);
[L,U,P] = lu(input_mat);
P=P'; %Matlab returns P' instead of P for some reason
% A = PLU

my_det = prod(diag(U)) * funcbund.detPerm(P); %L is promised to be with 1s in diagonal, doolittle
my_inv = funcbund.InverseU(U) * funcbund.InverseL(L) *P'; %inv(P) = P'
end

