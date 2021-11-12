%% Init
[A,b] = ODEmodel(20);

D = diag(diag(A));
L = -tril(A,-1);
U = -triu(A,1);

% Jacobi spectral radius
G = D\(L+U);
c = D\b;

Lambda = max(abs(eig(G)));

errors_x = 10.^-(1:0.1:7);

%% 5.2
x0 = zeros(20,1);
estimated_k = zeros(size(errors_x));
for ii = 1:length(errors_x)
    estimated_k(ii) = itr_est(x0,G,c,errors_x(ii));
end

figure(1)
plot(log10(errors_x),estimated_k,'o-','LineWidth',2);
ylabel('$$Estimated\;iterations$$','interpreter','latex');
xlabel('$$log(Error Bound)$$','interpreter','latex');
grid on;
grid minor;

norm_error = zeros(size(errors_x));
for ii = 1:61
    sol = iterative_solver(G,c,x0,round(estimated_k(ii)));
    norm_error(ii) = norm(A*sol-b,inf);
end
figure(2)
plot(errors_x,norm_error,'o')
ylabel('$$Error$$','interpreter','latex');
xlabel('$$Error Bound$$','interpreter','latex');
grid on;
grid minor;


function num_i = cal_iterations(G,C,x0,error)
x = G*x0 + C;
num_i = log((error*(1-norm(G,inf)))/norm(x-x0,inf))/log(norm(G,inf));
end