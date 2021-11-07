%% checkSquared(M)

A=magic(4);
n = funcbund.checkSquared(A);

disp('for A = magic(4):')
if n==4, disp('pass'), else disp('fail'); end

A=[A,A];
disp('for size(A) == [4,8]')
n = funcbund.checkSquared(A);

%% SolveUy
A=magic(7);
[~,U,~] = lu(A);

b=A(:,1);
y1 = funcbund.solveUy(U,b);
y2 = U\b;
disp('norm difference between my method and matlab"s')
disp(norm(y1-y2)/norm(y2))

%% InverseU
A=magic(7);
[~,U,~] = lu(A);

invU1 = funcbund.InverseU(U);
invU2 = inv(U);
disp('norm difference between my method and matlab"s')
disp(norm(invU2-invU1)/norm(invU2))

%% solveLx
A=magic(7);
[L,~,~] = lu(A);
b=A(:,1);

x1 = funcbund.solveLx(L,b);
x2 = L\b;
disp('norm difference between my method and matlab"s')
disp(norm(x1-x2)/norm(x2))

%% InverseL
A=magic(7);
[L,~,~] = lu(A);

invL1 = funcbund.InverseL(L);
invL2 = inv(L);
disp('norm difference between my method and matlab"s')
disp(norm(invL2-invL1)/norm(invL2))
