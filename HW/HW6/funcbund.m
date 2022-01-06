classdef funcbund
    properties(Constant)
    end
    methods(Static)
        function [x,fval,df,dx,exitflag,iterations,funcCount] = SteepestDecent(fun,x0,maxIters,StepTolerance)
            %we will use the BFGS quasi-newton method
            %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method

            %idea of newton's method:
            %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
            %D(f,xi) - gradient
            %H(f,xi) - hessian

            %in quasi-newton, instead of H we use A, which uses only first derivatives.
            %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)
            
            clear global;
            global outputFcn_global_data

            options = optimoptions(@fminunc,'Display','iter',...
                'Algorithm','quasi-newton','HessUpdate','steepdesc',...
                'MaxIterations',maxIters,...
                'StepTolerance',StepTolerance,...
                'OutputFcn',@outputFcn_global);
            [x,fval,exitflag,output] = fminunc(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;

            df = fun(outputFcn_global_data(end-1).x)-fun(outputFcn_global_data(end).x);
            dx = norm(outputFcn_global_data(end-1).x - outputFcn_global_data(end).x);
        end
        function [x,fval,df,dx,exitflag,iterations,funcCount] = QuasiNewton(fun,x0,maxIters,StepTolerance)
        %we will use the BFGS quasi-newton method
        %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method
        
        %idea of newton's method:
        %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
        %D(f,xi) - gradient
        %H(f,xi) - hessian
        
        %in quasi-newton, instead of H we use A, which uses only first derivatives.
        %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)
        
            clear global;
            global outputFcn_global_data


        options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton',...
            'MaxIterations',maxIters,...
            'StepTolerance',StepTolerance,...
            'OutputFcn',@outputFcn_global);
        [x,fval,exitflag,output] = fminunc(fun,x0,options);
        iterations = output.iterations;
        funcCount = output.funcCount;

        df = fun(outputFcn_global_data(end-1).x)-fun(outputFcn_global_data(end).x);
        dx = norm(outputFcn_global_data(end-1).x - outputFcn_global_data(end).x);
        end

        function [x,fval,exitflag,iterations,funcCount] = SimulatedAnealing(fun,x0,maxIters,FunctionTolerance)

            clear global;
            global outputFcn_global_data


            options = optimoptions('simulannealbnd','Display','iter',...
                'MaxIterations',maxIters,'FunctionTolerance',FunctionTolerance,...
                'OutputFcn',@outputFcn_global_sa);
            
            [x,fval,exitflag,output] = simulannealbnd(fun,x0,[],[],options);
            iterations = output.iterations;
            funcCount = output.funccount;

            df = fun(outputFcn_global_data(end-1).x)-fun(outputFcn_global_data(end).x);
            dx = norm(outputFcn_global_data(end-1).x - outputFcn_global_data(end).x);
        end

        function [x,fval,df,dx,exitflag,generations,funcCount] = GeneticAlgorithm(fun,x0,MaxGenerations,FunctionTolerance,Npop)
            clear global;
            global outputFcn_global_data


            options = optimoptions('ga','Display','iter',...
                'MaxGenerations',MaxGenerations,'FunctionTolerance',FunctionTolerance,...
                'OutputFcn',@outputFcn_global_ga,...
                'PopulationSize',Npop);

            nvars = length(x0);
            [x,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],[],[],[],options);
            generations = output.generations;
            funcCount = output.funccount;
            
            fmin_i = mean(outputFcn_global_data(end-1).Score);
            fmin_ip1 = mean(outputFcn_global_data(end).Score);
            x_i = mean(outputFcn_global_data(end-1).Population);
            x_ip1 = mean(outputFcn_global_data(end).Population);
            df = fmin_i - fmin_ip1;
            dx = norm(x_i-x_ip1);
        end

        function [x,fval,exitflag,iterations,funcCount] = DownhillSimplex(fun,x0,maxIters,StepTolerance)
            global outputFcn_global_data

            
            %explination on the algorithm:
            %https://www.mathworks.com/help/optim/ug/fminsearch-algorithm.html
            options = optimset('Display','iter',...
                'TolX',StepTolerance,...
                'MaxIter',maxIters);

            [x,fval,exitflag,output] = fminsearch(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;
        end
    
    end
end