function sol_itr = iterative_solver(G,c,x0,k)
if (k == 0)
    sol_itr = x0;
else
    x0 = G*x0 + c;
    sol_itr = iterative_solver(G,c,x0,k-1);
end
end