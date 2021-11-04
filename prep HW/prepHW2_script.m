%% Question2

A=[17 -2 -3; -5 21 -2; -5 -5 22];
b=[500 200 30]';
D=diag(diag(A));

disp('inv(D)*(D-A)')
disp(inv(D)*(D-A))

disp('inv(D)*b')
disp(inv(D)*b)

x=[0 0 0]';
f =@(x) inv(D)*(D-A)*x + inv(D)*b;

disp('x_1');
disp(f(x));

disp('x_2');
disp(f(f(x)));

disp('x_3');
disp(f(f(f(x))));
x_3=f(f(f(x)));
%% Question 3

A = [-5 0 12; 4 -1 -1; 6 8 0]; b=[80 -2 45]';
P = [0 1 0; 0 0 1; 1 0 0];
A = P*A; b = P*b;

n=length(b);
C_L=zeros(size(A));
for ii=1:n
    for jj=1:n
        C_L(ii,jj) = -A(ii,jj) * double(jj<ii);
    end
end

D = diag(diag(A));
Q = D - C_L;
x = [0 0 0]';

disp('inv(Q)*(Q-A)')
disp(inv(Q)*(Q-A))

disp('inv(Q)*b')
disp(inv(Q)*b)

x=[0 0 0]';
f =@(x) inv(Q)*(Q-A)*x + inv(Q)*b;

disp('x_1');
disp(f(x));

disp('x_2');
disp(f(f(x)));

disp('x_3');
disp(f(f(f(x))));
x_3=f(f(f(x)));