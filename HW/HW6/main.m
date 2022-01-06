%% Vectorize the given functions
fEasom = @(x) Easom(x(1),x(2));
fEggholder = @(x) Eggholder(x(1),x(2));
fRosenbrock = @(x) Rosenbrock(x(1),x(2));

maxIters = 1e4;
StepTolerance = 1e-4;

%different settings for ga and sa
MaxGenerations = 100;
Npop = 50; %ga
FunctionTolerance = StepTolerance;





%% Steepest Decent
[x,fval,df,dx,exitflag,iterations,funcCount] = funcbund.SteepestDecent(fEasom,[2,2],maxIters,StepTolerance);

%% Quasi-Newton
[x,fval,df,dx,exitflag,iterations,funcCount]  = funcbund.QuasiNewton(fEasom,[2,2],maxIters,StepTolerance);

%% Simulated annealing
[x,fval,df,dx,exitflag,iterations,funcCount] = funcbund.SimulatedAnealing(fEasom,[2,2],maxIters,FunctionTolerance);

%% Genetic Algorithm
[x,fval,df,dx,exitflag,generations,funcCount] = funcbund.GeneticAlgorithm(fEasom,[2,2],MaxGenerations,FunctionTolerance,Npop);

%% Downhill simplex
[x,fval,exitflag,iterations,funcCount] = funcbund.DownhillSimplex(fEasom,[2,2],maxIters,StepTolerance);