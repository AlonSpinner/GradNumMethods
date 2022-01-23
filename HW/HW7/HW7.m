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
solk=sym(zeros(1,length(vars)));
k=1;
for ii=1:length(vars)
   solk(ii) = sol.(string(vars(ii)))(k);
end

%asumming the variables will always be arranged [w,x] as in our case:
solx = solk(N+1:end);
solw = solk(1:N);
[~,I] = sort(double(solx));

format long
disp('==================================================================');
disp('Solution:');
disp([w,x]);
disp([solw(I),solx(I)]);
disp('==================================================================');

%% Question 2 function and general parameters
f = @(x) x.^2.*atan(x);
a=0; b=2; N=3;

varNames = {'I','Error','h'};
varTypes = {'double','double','double'};
rowNames = {'Analytical';'NC-closed';'NC-open';'GQ'};
T = table('Size',[length(rowNames),length(varNames)],'VariableTypes',varTypes,...
    'RowNames',rowNames,'VariableNames',varNames);
T.("x") = zeros(length(rowNames),N);
T.("f(x)") = zeros(length(rowNames),N);
%% Question 2-a: analytical
syms x
disp(int(f(x)));
I = int(f(x),a,b);
T("Analytical","I") = {double(I)};
%% Question 2-b: Closed Newton Cotes
%from lecture, we have given Simpson's rule
h=(b-a)/(N-1);
x = (a:h:b)';
w = h/3*[1,4,1];
I = w*f(x);
T("NC-closed","I") = {I};
T("NC-closed","h") = {h};
T("NC-closed","x") = {x'};
T("NC-closed","f(x)") = {f(x')};
%% Question 2-c: Open Newton Cotes/2 
h=(b-a)/(N+1);
x = (a+h:h:b-h)';
w = 4*h/3*[2,-1,2];
I = w*f(x);
T("NC-open","I") = {I};
T("NC-open","h") = {h};
T("NC-open","x") = {x'};
T("NC-open","f(x)") = {f(x')};
%% Question 2-d: Qauss Quadrature
w = [5/9, 8/9, 5/9];
z = [-15^(1/2)/5, 0, 15^(1/2)/5]';
fz2x = @(z) 0.5*((b-a)*z + (b+a));
x = fz2x(z);
I = w*f(x);
T("GQ","I") = {I};
T("GQ","h") = {NaN};
T("GQ","x") = {x'};
T("GQ","f(x)") = {f(x')};
%% Question 2-e: Compare
T(:,"Error") = num2cell(table2array(T(:,"I")) - table2array(T("Analytical","I")));

fig = figure('color',[1,1,1]); 
ax=axes(fig);
hold(ax,'on'); grid(ax,'on'); title(ax,'function and integration points');
xlabel(ax,'x'); ylabel(ax,'f(x)'); 
x = linspace(a,b,1000);
plot(ax,x,f(x));
scatter(ax,table2array(T("NC-closed","x")),table2array(T("NC-closed","f(x)"))...
    ,100,'o','LineWidth',2)
scatter(ax,table2array(T("NC-open","x")),table2array(T("NC-open","f(x)"))...
    ,100,'+','LineWidth',2)
scatter(ax,table2array(T("GQ","x")),table2array(T("GQ","f(x)"))...
    ,100,'sq','LineWidth',2)
legend(ax,[{'f(x)'},T.Properties.RowNames(2:end)'],"location","best");

%% Question 3
syms n real;
Et_n = 2^(2*n+3)*(factorial(n+1))^4/((2*n+3)*factorial(2*n+2)^3);
Et_np1 = simplify(subs(Et_n,n+1),1000);
q = simplify(Et_np1/Et_n,1000);
epsilon = 1e-6;
disp(vpasolve(q == epsilon));


%% Question 3-a: f = exp(2*x)*sin(2*x)

fun = @(x) exp(2*x)*sin(2*x);
a = 0; b = pi/4; n = 1000; epsilon=1e-5;
I = AdaptQuad(fun,a,b,n,epsilon);
q = integral(fun,xmin,xmax)