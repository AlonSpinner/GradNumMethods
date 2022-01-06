%% Vectorize the given functions
fEasom = @(x) Easom(x(1),x(2));
fEggholder = @(x) Eggholder(x(1),x(2));
fRosenbrock = @(x) Rosenbrock(x(1),x(2));

%% Quasi-Newton
[x,fval,exitflag,iterations,funcCount] = funcbund.QuasiNewton(fEasom,[2,2]);

%% Simulated annealing
[x,fval,exitflag,iterations,funcCount] = funcbund.SimulatedAnealing(fEasom,[2,2]);

%% Genetic Algorithm
[x,fval,exitflag,iterations,funcCount] = funcbund.GeneticAlgorithm(fEasom,[2,2]);