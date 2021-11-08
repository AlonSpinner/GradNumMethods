%%
n = 100;
[A,b] = ODEmodel(n);

%% 4.1
[G,c] = funcbund.prepGausSiedel(A,b);
x0 = zeros(n,1);
threshold = 1e-2;
[k,upperbound] = itr_est(x0,G,c,threshold);
fprintf('k = %d\n',k);
fprintf('upperbound = %d\n',upperbound);
%% 4.2
xk = funcbund.iterative_solver(G,c,x0,k);
rk = norm(A*xk-b,'inf');
fprintf('rk by GS = %d\n',rk);
%% 4.3
xstar = gauss_elim(A,b,true);
rstar=norm(A*xstar-b,'inf');
fprintf('r by Gauss Elimination = %d\n',rstar);

%% 4.4
tic
xk = funcbund.iterative_solver(G,c,x0,k);
timeGS = toc;
fprintf('timeGS = %d[s]\n',timeGS);


tic
xstar = gauss_elim(A,b,true);
timeGE = toc;
fprintf('timeGE = %d[s]\n',timeGE);