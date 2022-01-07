%% Vectorize the given functions
fEasom = @(x) Easom(x(1),x(2));
fRosenbrock = @(x) Rosenbrock(x(1),x(2));
fEggholder = @(x) Eggholder(x(1),x(2));

%settings
maxIters = 1e4;
StepTolerance = 1e-4;

%different settings for ga
ga_MaxGenerations = 100;
    ga_Npop = 50; %ga
ga_FunctionTolerance = 1e-4;

%different settings for sa
sa_FunctionTolerance = 1e-4;

K = 5; %number of times to run each solver on each function
M = 5; %number of methods

%Table template construction
methods = {'SteepestDecent','QuasiNewton','SimulatedAnealing','GeneticAlgorithm','DownhillSimplex'};
VarNames = [{'x0'},methods];
VarTypes = {'cell','cell','cell','cell','cell','cell'}; %M Times
rowNames = {'sol1','sol2','sol3','sol4','sol5'}; %K Times
T = table('Size',[K,M+1],'VariableTypes',VarTypes,...
    'RowNames',rowNames,'VariableNames',VarNames);

%function limits [xmin,xmax,ymin,ymax]
EasomLimits = [0 5, 0 5];
RosenbrockLimits = [-3 3, -1 6];
EggholderLimits = [0 500, 0 500];
%% Plots
figure;
fsurf(@Easom,EasomLimits);
title('Easom'); xlabel('x'); ylabel('y'); zlabel('z');

figure;
fsurf(@Rosenbrock,RosenbrockLimits);
title('Rosenbrock'); xlabel('x'); ylabel('y'); zlabel('z');


figure;
fsurf(@Eggholder,EggholderLimits);
title('Eggholder'); xlabel('x'); ylabel('y'); zlabel('z');
%% Easom
[A,m] = funcbund.Limits2AmpAndMean(EasomLimits);
x0 = (rand(K,2)-0.5).*A+m;
T_Easom = T;
for ii=1:K
    T_Easom.x0{ii} = x0(ii,:);
end

for ii=1:K %first col is x0
[x,fval] = funcbund.SteepestDecent(fEasom,x0(ii,:),maxIters,StepTolerance);
T_Easom.SteepestDecent{ii} = [x,fval];

[x,fval]  = funcbund.QuasiNewton(fEasom,x0(ii,:),maxIters,StepTolerance);
T_Easom.QuasiNewton{ii} = [x,fval];

[x,fval]= funcbund.SimulatedAnealing(fEasom,x0(ii,:),maxIters,sa_FunctionTolerance);
T_Easom.SimulatedAnealing{ii} = [x,fval];

[x,fval]= funcbund.GeneticAlgorithm(fEasom,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
T_Easom.GeneticAlgorithm{ii} = [x,fval];

[x,fval,exitflag,iterations,funcCount] = funcbund.DownhillSimplex(fEasom,x0(ii,:),maxIters,StepTolerance);
T_Easom.DownhillSimplex{ii} = [x,fval];
end

funcbund.plotResults(@Easom,EasomLimits,T_Easom,'Easom');
Easom_bestSolsInds = funcbund.findBestAttempt(T_Easom);
%% Rosenbrock
[A,m] = funcbund.Limits2AmpAndMean(RosenbrockLimits);
x0 = (rand(K,2)-0.5).*A+m;
T_Rosenbrock = T;
for ii=1:K
[T_Rosenbrock.SteepestDecent{ii},fval,exitflag,iterations,funcCount] = funcbund.SteepestDecent(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.QuasiNewton{ii},fval,exitflag,iterations,funcCount]  = funcbund.QuasiNewton(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.SimulatedAnealing{ii},fval,exitflag,iterations,funcCount] = funcbund.SimulatedAnealing(fRosenbrock,x0(ii,:),maxIters,sa_FunctionTolerance);
[T_Rosenbrock.GeneticAlgorithm{ii},fval,exitflag,generations,funcCount] = funcbund.GeneticAlgorithm(fRosenbrock,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
[T_Rosenbrock.DownhillSimplex{ii},fval,exitflag,iterations,funcCount] = funcbund.DownhillSimplex(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
end

funcbund.plotResults(@Rosenbrock,RosenbrockLimits,T_Rosenbrock,'Rosenbrock');
%% EggHolder
[A,m] = funcbund.Limits2AmpAndMean(EggholderLimits);
x0 = (rand(K,2)-0.5).*A+m;
T_EggHolder = T;
for ii=1:K
[T_EggHolder.SteepestDecent{ii},fval,exitflag,iterations,funcCount] = funcbund.SteepestDecent(fEggholder,x0(ii,:),maxIters,StepTolerance);
[T_EggHolder.QuasiNewton{ii},fval,exitflag,iterations,funcCount]  = funcbund.QuasiNewton(fEggholder,x0(ii,:),maxIters,StepTolerance);
[T_EggHolder.SimulatedAnealing{ii},fval,exitflag,iterations,funcCount] = funcbund.SimulatedAnealing(fEggholder,x0(ii,:),maxIters,sa_FunctionTolerance);
[T_EggHolder.GeneticAlgorithm{ii},fval,exitflag,generations,funcCount] = funcbund.GeneticAlgorithm(fEggholder,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
[T_EggHolder.DownhillSimplex{ii},fval,exitflag,iterations,funcCount] = funcbund.DownhillSimplex(fEggholder,x0(ii,:),maxIters,StepTolerance);
end

funcbund.plotResults(@Eggholder,EggholderLimits,T_EggHolder,'Eggholder');