load('BadGaussMatr.mat')

tic
sol = gauss_elim(A,b,0);
without_piv_time = toc
tic
sol_piv = gauss_elim(A,b,1);
with_pivot = toc
tic
comp = A\b;
compare_time = toc

error_without_pivot = norm(sol-x)

error_with_pivot = norm(sol_piv-x)

