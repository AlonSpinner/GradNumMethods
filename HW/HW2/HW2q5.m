[A,b] = ODEmodel(20);

D = diag(diag(A));
L = -tril(A,-1);
U = -triu(A,1);


% Jacobi spectral radius
T = D\(L+U);
C = D\b;

Lambda = max(abs(eig(T)));

% 5.2
x0 = zeros(20,1);
estimated_k = [];
for i = 1:0.1:7
    num_iterations = cal_iterations(T,C,x0,10^-i);
    estimated_k = [estimated_k;num_iterations];
end

figure(1)
plot(1:0.1:7,estimated_k,'o-','LineWidth',2);
ylabel('$$Estimated\;iterations$$','interpreter','latex');
xlabel('$$Error$$','interpreter','latex');
grid on;
grid minor;

norm_error = [];
for i = 1:61
    sol = iterative_solver(T,C,x0,round(estimated_k(i)));
    norm_error = [norm_error,norm(A*sol-b,inf)];
end
figure(2)
errors_x = 10.^-(1:0.1:7);
plot(errors_x,norm_error,'o')
ylabel('$$Error$$','interpreter','latex');
xlabel('$$Boundery$$','interpreter','latex');
grid on;
grid minor;


function num_i = cal_iterations(G,C,x0,error)
x = G*x0 + C;
num_i = log((error*(1-norm(G,inf)))/norm(x-x0,inf))/log(norm(G,inf));
end