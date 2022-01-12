%% Vectorize the given functions
fEasom = @(x) Easom(x(1),x(2));
fRosenbrock = @(x) Rosenbrock(x(1),x(2));
fEggholder = @(x) Eggholder(x(1),x(2));

%settings
maxIters = 1e4;
StepTolerance = 1e-4;

%different settings for ga
ga_MaxGenerations = 1e4;
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
% T_Easom = T;
% for ii=1:K
%     T_Easom.x0{ii} = x0(ii,:);
% end
E_data_Qn = zeros(5,9);
E_data_simplex = zeros(5,9);
E_data_Ge = zeros(5,9);
E_data_St = zeros(5,9);
E_data_Sa = zeros(5,9);
for ii=1:K %first col is x0
[T_Rosenbrock.SteepestDecent{ii},fval,exitflag,iterations,funcCount,E_data_St(ii,:)] = funcbund.SteepestDecent(fEasom,x0(ii,:),maxIters,StepTolerance);

[T_Rosenbrock.QuasiNewton{ii},fval,exitflag,iterations,funcCount,E_data_Qn(ii,:)]  = funcbund.QuasiNewton(fEasom,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.SimulatedAnealing{ii},fval,exitflag,iterations,funcCount,E_data_Sa(ii,:)] = funcbund.SimulatedAnealing(fEasom,x0(ii,:),maxIters,sa_FunctionTolerance);
[T_Rosenbrock.GeneticAlgorithm{ii},fval,exitflag,generations,funcCount,E_data_Ge(ii,:)] = funcbund.GeneticAlgorithm(fEasom,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
[T_Rosenbrock.DownhillSimplex{ii},fval,exitflag,iterations,funcCount,E_data_simplex(ii,:)] = funcbund.DownhillSimplex(fEasom,x0(ii,:),maxIters,StepTolerance);

end

% funcbund.plotResults(@Easom,EasomLimits,T_Easom,'Easom');
% Easom_bestSolsInds = funcbund.findBestAttempt(T_Easom);
%% Rosenbrock
[A,m] = funcbund.Limits2AmpAndMean(RosenbrockLimits);
x0 = (rand(K,2)-0.5).*A+m;
% T_Rosenbrock = T;
R_data_Qn = zeros(5,9);
R_data_simplex = zeros(5,9);
R_data_Ge = zeros(5,9);
R_data_St = zeros(5,9);
R_data_Sa = zeros(5,9);
for ii=1:K
[T_Rosenbrock.SteepestDecent{ii},fval,exitflag,iterations,funcCount,R_data_St(ii,:)] = funcbund.SteepestDecent(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.QuasiNewton{ii},fval,exitflag,iterations,funcCount,R_data_Qn(ii,:)]  = funcbund.QuasiNewton(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.SimulatedAnealing{ii},fval,exitflag,iterations,funcCount,R_data_Sa(ii,:)] = funcbund.SimulatedAnealing(fRosenbrock,x0(ii,:),maxIters,sa_FunctionTolerance);
[T_Rosenbrock.GeneticAlgorithm{ii},fval,exitflag,generations,funcCount,R_data_Ge(ii,:)] = funcbund.GeneticAlgorithm(fRosenbrock,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
[T_Rosenbrock.DownhillSimplex{ii},fval,exitflag,iterations,funcCount,R_data_simplex(ii,:)] = funcbund.DownhillSimplex(fRosenbrock,x0(ii,:),maxIters,StepTolerance);
end
% funcbund.plotResults(@Rosenbrock,RosenbrockLimits,T_Rosenbrock,'Rosenbrock');
%% EggHolder
[A,m] = funcbund.Limits2AmpAndMean(EggholderLimits);
while(1)
    x0 = (rand(K,2)-0.5).*A+m;
    if (x0(1)>=0 && x0(2)<=500)
        break
    end
end
Eg_data_Qn = zeros(5,9);
Eg_data_simplex = zeros(5,9);
Eg_data_Ge = zeros(5,9);
Eg_data_St = zeros(5,9);
Eg_data_Sa = zeros(5,9);
% T_EggHolder = T;
for ii=1:K
[T_Rosenbrock.SteepestDecent{ii},fval,exitflag,iterations,funcCount,Eg_data_St(ii,:)] = funcbund.SteepestDecent(fEggholder,x0(ii,:),maxIters,StepTolerance);
[T_EggHolder.QuasiNewton{ii},fval,exitflag,iterations,funcCount,Eg_data_Qn(ii,:)]  = funcbund.QuasiNewton(fEggholder,x0(ii,:),maxIters,StepTolerance);
[T_Rosenbrock.SimulatedAnealing{ii},fval,exitflag,iterations,funcCount,Eg_data_Sa(ii,:)] = funcbund.SimulatedAnealing(fEggholder,x0(ii,:),maxIters,sa_FunctionTolerance);
[T_Rosenbrock.GeneticAlgorithm{ii},fval,exitflag,generations,funcCount,Eg_data_Ge(ii,:)] = funcbund.GeneticAlgorithm(fEggholder,x0(ii,:),ga_MaxGenerations,ga_FunctionTolerance,ga_Npop);
[T_Rosenbrock.DownhillSimplex{ii},fval,exitflag,iterations,funcCount,Eg_data_simplex(ii,:)] = funcbund.DownhillSimplex(fEggholder,x0(ii,:),maxIters,StepTolerance);
end

% funcbund.plotResults(@Eggholder,EggholderLimits,T_EggHolder,'Eggholder');