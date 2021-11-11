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
N=100;
[timeGS,timeGE]=deal(zeros(size(N,1)));

for ii=1:N
tic
xk = funcbund.iterative_solver(G,c,x0,k);
timeGS(ii) = toc;

tic
xstar = gauss_elim(A,b,true);
timeGE(ii) = toc;
end

fprintf('timeGS = %d[s]\n',mean(timeGS));
fprintf('timeGE = %d[s]\n',mean(timeGE));