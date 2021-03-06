classdef funcbund
    properties(Constant)
    end
    methods(Static)
        function [x,fval,exitflag,iterations,funcCount,data] = SteepestDecent(fun,x0,maxIters,StepTolerance)
            %we will use the BFGS quasi-newton method
            %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method

            %idea of newton's method:
            %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
            %D(f,xi) - gradient
            %H(f,xi) - hessian

            %in quasi-newton, instead of H we use A, which uses only first derivatives.
            %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)
            clear outputFcn_global_data;
            global outputFcn_global_data;

            options = optimoptions(@fminunc,'Display','iter',...
                'Algorithm','quasi-newton','HessUpdate','steepdesc',...
                'MaxIterations',maxIters,'MaxFunctionEvaluations',inf,...
                'StepTolerance',StepTolerance,'OutputFcn',@outputFcn_global);
            [x,fval,exitflag,output] = fminunc(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;

            LastStepSize = norm(outputFcn_global_data(end).x - outputFcn_global_data(end-1).x);
            LastValueChange = norm(fun(outputFcn_global_data(end-1).x) - fun(outputFcn_global_data(end).x));
        
            data = [iterations,output.funcCount,LastStepSize,LastValueChange,x0,x,fval];
        end
        function [x,fval,exitflag,iterations,funcCount,data] = QuasiNewton(fun,x0,maxIters,StepTolerance)
        %we will use the BFGS quasi-newton method
        %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method
        
        %idea of newton's method:
        %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
        %D(f,xi) - gradient
        %H(f,xi) - hessian
        
        %in quasi-newton, instead of H we use A, which uses only first derivatives.
        %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)

        clear outputFcn_global_data;
        global outputFcn_global_data;

        options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton',...
            'MaxIterations',maxIters,...
            'StepTolerance',StepTolerance,'OutputFcn',@outputFcn_global);
        [x,fval,exitflag,output] = fminunc(fun,x0,options);
        iterations = output.iterations;
        funcCount = output.funcCount;
        LastStepSize = norm(outputFcn_global_data(end).x - outputFcn_global_data(end-1).x);
        LastValueChange = norm(fun(outputFcn_global_data(end-1).x) - fun(outputFcn_global_data(end).x));
        
        data = [iterations,output.funcCount,LastStepSize,LastValueChange,x0,x,fval]
        end

        function [x,fval,exitflag,iterations,funcCount,data] = SimulatedAnealing(fun,x0,maxIters,FunctionTolerance)
            clear outputFcn_global_data;
            global outputFcn_global_data;
            
            options = optimoptions('simulannealbnd','Display','iter',...
                'MaxIterations',maxIters,'FunctionTolerance',FunctionTolerance,'OutputFcn',@sa_outputFcn_global);
            
            [x,fval,exitflag,output] = simulannealbnd(fun,x0,[],[],options);
            iterations = output.iterations;
            funcCount = output.funccount;
            LastStepSize = norm(outputFcn_global_data(end).state.x - outputFcn_global_data(end-1).state.x);
            LastValueChange = norm(outputFcn_global_data(end-1).state.fval - outputFcn_global_data(end-1).state.fval);
            data = [iterations,funcCount,LastStepSize,LastValueChange,x0,x,fval];
        end

        function [x,fval,exitflag,generations,funcCount,Data] = GeneticAlgorithm(fun,x0,MaxGenerations,FunctionTolerance,Npop)
            clear outputFcn_global_data;
            global outputFcn_global_data;
            
            options = optimoptions('ga','Display','iter',...
                'MaxGenerations',MaxGenerations,'FunctionTolerance',FunctionTolerance,...
                'PopulationSize',Npop,'OutputFcn',@ga_outputFcn_global);

            

            nvars = length(x0);
            [x,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],[],[],[],options);
            generations = output.generations;
            funcCount = output.funccount;
            f_mean_change = norm(mean(outputFcn_global_data(end).state.Score) - mean(outputFcn_global_data(end-1).state.Score));
            f_change = norm(outputFcn_global_data(end).state.Best(end) - outputFcn_global_data(end).state.Best(end-1));
            [~,index] = min(outputFcn_global_data(1).state.Score);
            x_init_best = outputFcn_global_data(1).state.Population(8,:);
            Data = [generations,funcCount,f_mean_change,f_change,x_init_best,x,fval];
        end

        function [x,fval,exitflag,iterations,funcCount,data] = DownhillSimplex(fun,x0,maxIters,StepTolerance) 
            %explination on the algorithm:
            %https://www.mathworks.com/help/optim/ug/fminsearch-algorithm.html

        clear outputFcn_global_data;
        global outputFcn_global_data;
            options = optimset('Display','iter',...
                'TolX',StepTolerance,...
                'MaxIter',maxIters,'OutputFcn',@outputFcn_global);

            [x,fval,exitflag,output] = fminsearch(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;

            LastStepSize = norm(outputFcn_global_data(end).x - outputFcn_global_data(end-1).x);
            LastValueChange = norm(fun(outputFcn_global_data(end-1).x) - fun(outputFcn_global_data(end).x));
            data = [iterations,output.funcCount,LastStepSize,LastValueChange,x0,x,fval]

        end
        
        function [A,m] = Limits2AmpAndMean(limits)
        %limits - [xmin,xmax,ymin,ymax]
        A = [limits(2)-limits(1),limits(4)-limits(3)];
        m =  [mean(limits(1:2)),mean(limits(3:4))];
        end

        function plotResults(fun,Limits,T,funName)
            fig = figure;
            ax=axes(fig); hold(ax,'on');
            xlabel('x'); ylabel('y'); zlabel('z');
            fsurf(ax,fun,Limits,'EdgeColor','none');
            axis('manual');
            
            methods = T.Properties.VariableNames(2:end); %first col is x0
            entries = T.Variables;
            entries = entries(:,2:end); %first col is x0
            shapes = {'o','+','*','x','s','d','p','h','^'};
            colors = jet(length(methods));
            for ii=1:length(methods) %first col is x0
                sols = cell2mat(entries(:,ii));
                z = sols(:,3) + 1; %allow rendeer to show points above
                scatter3(ax,sols(:,1),sols(:,2),z,50,shapes{ii},...
                    'LineWidth',2,'MarkerEdgeColor',colors(ii,:));
            end
            legend([{funName},methods],'location','best');
            colorbar(ax);
            colormap(ax,'gray');
        end

        function bestSolsInds = findBestAttempt(T)
            T = T(:,2:end); %dont care about x0 column
            Nmethods = length(T.Properties.VariableNames);
            bestSolsInds = zeros(1,Nmethods);
            for ii=1:Nmethods
                data = cell2mat(table2array(T(:,ii)));
                [~,bestSolsInds(ii)] = min(data(:,3));
            end
        end
    end
end