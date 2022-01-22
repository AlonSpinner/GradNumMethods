%% Question 1
M=3;
x=sym('x',[1,M],'real');
w = sym('w',[1,M],'real');

%compute coeff
c = zeros(1,2*M);
syms z real
for ii=1:length(c)
    c(ii) = int(z^(ii-1),-1,1);
end

%create equations array
eq = sym(zeros(1,2*M));
for ii=1:length(eq)
    eq(ii) = w*(x.^(ii-1))' == c(ii);
end

vars = symvar(eq);
sol = solve(eq);

%the symetrical nature of the problem will gaurantuee 2*N permutations.
%choose the first one, and sort it by the xs
solk=zeros(1,length(vars));
k=1;
for ii=1:length(vars)
   solk(ii) = sol.(string(vars(ii)))(k);
end

%asumming the variables will always be arranged [w,x] as in our case:
solx = solk(N+1:end);
solw = solk(1:N);
[~,I] = sort(solx);

disp('==================================================================');
disp('Solution:');
disp([w,x]);
disp([solw(I),solx(I)]);
disp('==================================================================');