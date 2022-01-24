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
solx = solk(M+1:end);
solw = solk(1:M);
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
disp(ceil(max(vpasolve(q == epsilon))));

fq = matlabFunction(q);
n = 1:1000;
fig = figure('color',[1,1,1]); 
ax=axes(fig);
hold(ax,'on'); grid(ax,'on'); 
plot(ax,n,fq(n));
ax.XScale = 'log';
xlabel(ax,'n'); ylabel(ax,'E_t(n+1)/E_t(n)');
title(ax,sprintf('Gauss Quadrature\nRational Between Consecutive Error Terms'));

q = simplify(abs(Et_np1-Et_n),1000);
fq = matlabFunction(q);
n = 1:1000;
fig = figure('color',[1,1,1]); 
ax=axes(fig);
hold(ax,'on'); grid(ax,'on'); 
plot(ax,n,fq(n));
ax.XScale = 'log'; ax.YScale = 'log';
xlabel(ax,'n'); ylabel(ax,'\alpha * abs(E_t(n+1) - E_t(n))');
title(ax,sprintf('Gauss Quadrature\nDistance Between Error Terms'));

%% Question 3-a: f = exp(3*x)*sin(2*x)
syms x
a = 0; b = pi/4;
Itrue = int(exp(3*x)*sin(2*x),a,b);

epsilon=1e-6;
n=2:10;
f = @(x) exp(3*x).*sin(2*x);
k = 10; %number of repeated iterations on each integral for better time computation

%construct data
[AGQ,timeAGQ,GQevals] = deal(zeros(size(n)));
for ii = 1:length(n)
    I = 0; evals = 0;
    tic;
    for jj=1:k
        [I_jj,evals_jj] = AdaptQuad(f,a,b,n(ii),epsilon);
        I = I + I_jj;
        evals = evals + evals_jj;
    end
    AGQ(ii) = I/k;
    timeAGQ(ii) = toc/k;
    GQevals(ii) = evals/k;
    disp(ii);
end
%MATLAB result and time
I = 0;
tic;
for jj=1:k
    I = I + integral(f,a,b,'RelTol',epsilon);
end
IMATLAB = I/k;
timeMATLAB = toc/k;

eMATLAB = abs(IMATLAB - Itrue);
eAGQ = abs(AGQ - Itrue);

%----------------------------------PLOT
fig = figure('color',[1,1,1]); 
tlo = tiledlayout(fig,1,3);
title(tlo,'f(x) = exp(3*x)*sin(2*x)','FontSize',15,'FontWeight','Bold');
%Computation time
nexttile(tlo);
hold('on'); grid('on'); 
title('Computation Time');
xlabel('n'); ylabel('Computation Time[s]'); 
plot(n,timeAGQ);
plot([n(1),n(end)],timeMATLAB*[1,1]);
legend("Adaptive Gauss Quadrature", "MATLAB's integral");
%integration error
nexttile(tlo);
hold('on'); grid('on'); 
title('Integration Error');
xlabel('n'); ylabel('Absolute Error'); 
plot(n,eAGQ);
plot([n(1),n(end)],eMATLAB*[1,1]);
legend("Adaptive Gauss Quadrature", "MATLAB's integral");
set(gca,'XScale','log');
set(gca,'YScale','log');
%evaluations
nexttile(tlo);
hold('on'); grid('on');
title('GQ Evaluations vs Initial n');
xlabel('n'); ylabel('GQ Evaluations');   
bar(n,GQevals);
%% Question 3-b: f = x.*sin(x^2)
syms x
a = 0; b = pi;
Itrue = int(x*sin(x^2),a,b);

epsilon=1e-6;
n=2:10;
f = @(x) x.*sin(x.^2);
k = 10; %number of repeated iterations on each integral for better time computation

%construct data
[AGQ,timeAGQ,GQevals] = deal(zeros(size(n)));
for ii = 1:length(n)
    I = 0; evals = 0;
    tic;
    for jj=1:k
        [I_jj,evals_jj] = AdaptQuad(f,a,b,n(ii),epsilon);
        I = I + I_jj;
        evals = evals + evals_jj;
    end
    AGQ(ii) = I/k;
    timeAGQ(ii) = toc/k;
    GQevals(ii) = evals/k;
    disp(ii);
end
%MATLAB result and time
I = 0;
tic;
for jj=1:k
    I = I + integral(f,a,b,'RelTol',epsilon);
end
IMATLAB = I/k;
timeMATLAB = toc/k;

eMATLAB = abs(IMATLAB - Itrue);
eAGQ = abs(AGQ - Itrue);

%----------------------------------PLOT
fig = figure('color',[1,1,1]); 
tlo = tiledlayout(fig,1,3);
title(tlo,'f(x) = x*sin(x^2)','FontSize',15,'FontWeight','Bold');
%Computation time
nexttile(tlo);
hold('on'); grid('on'); 
title('Computation Time');
xlabel('n'); ylabel('Computation Time[s]'); 
plot(n,timeAGQ);
plot([n(1),n(end)],timeMATLAB*[1,1]);
legend("Adaptive Gauss Quadrature", "MATLAB's integral");
%integration error
nexttile(tlo);
hold('on'); grid('on'); 
title('Integration Error');
xlabel('n'); ylabel('Absolute Error'); 
plot(n,eAGQ);
plot([n(1),n(end)],eMATLAB*[1,1]);
legend("Adaptive Gauss Quadrature", "MATLAB's integral");
set(gca,'XScale','log');
set(gca,'YScale','log');
%evaluations
nexttile(tlo);
hold('on'); grid('on');
title('GQ Evaluations vs Initial n');
xlabel('n'); ylabel('GQ Evaluations');   
bar(n,GQevals);

%Find out about "luck"
fig=figure('color',[1,1,1]);
tlo = tiledlayout(fig,'flow');
title(tlo,'f(x) = x*sin(x^2) with Luck','FontSize',15,'FontWeight','Bold');

n = [2:3];
for ii=n
    nexttile(tlo);
    [x,w] = lgwt(ii,a,b); %both column vectors
    %assume function was not written for a vectorized x
    t=linspace(a,b,1000);
    hold('on'); grid('on');
    plot(t,f(t));
    scatter(x,f(x),50);
    xlabel('x'); ylabel('y');
    legend('f(x)','GQ integration points');
end