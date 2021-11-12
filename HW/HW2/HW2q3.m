[A,b] = ODEmodel(8);
err_methods = {};

exact_sol = A\b;
x = zeros(8,1);
k = 10
for i = 1:k
    D = diag(diag(A));
    L = -tril(A,-1);
    U = -triu(A,1);

    % Richardson method
    T = eye(8)-A;
    C = b;

    RI_sol_iter = iterative_solver(T,C,x,i);
    err_methods{1}(i) = norm(exact_sol-RI_sol_iter)

    % Jacobi method
    T = D\(L+U);
    C = D\b;
    Ja_sol_iter = iterative_solver(T,C,x,i);
    err_methods{2}(i) = norm(exact_sol-Ja_sol_iter)
    % Gauss-Seidel
    T = (D-L)\U;
    C = (D-L)\b;
    Ga_sol_iter = iterative_solver(T,C,x,i);
   err_methods{3}(i) = norm(exact_sol-Ga_sol_iter)
end
err_methods{4} = 1:10;
plot(err_methods{4},err_methods{1},'b')
hold on
plot(err_methods{4},err_methods{2},'r')
plot(err_methods{4},err_methods{3},'g')
ylim([0,10])
legend("$$Richardson$$",'$$Jacobi$$','$$Gauss-Seidel$$','interpreter','latex')
ylabel("$$error$$",'interpreter','latex')
xlabel("$$iteration$$",'interpreter','latex')