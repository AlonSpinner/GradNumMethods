[A,b] = ODEmodel(8);
exact_sol = A\b;
x = zeros(8,1);
k = 10

D = diag(diag(A));
L = -tril(A,-1);
U = -triu(A,1);

% Richardson method
T = eye(8)-A;
C = b;

RI_sol_iter = iterative_solver(T,C,x,k);
norm(exact_sol-RI_sol_iter)

% Jacobi method
T = D\(L+U);
C = D\b;
Ja_sol_iter = iterative_solver(T,C,x,k);
norm(exact_sol-Ja_sol_iter)
% Gauss-Seidel
T = (D-L)\U;
C = (D-L)\b;
Ga_sol_iter = iterative_solver(T,C,x,k);
norm(exact_sol-Ga_sol_iter)