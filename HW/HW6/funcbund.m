classdef funcbund
    properties(Constant)
    end
    methods(Static)
        function [x,fval,exitflag,iterations,funcCount] = SteepestDecent(fun,x0,maxIters,StepTolerance)
            %we will use the BFGS quasi-newton method
            %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method

            %idea of newton's method:
            %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
            %D(f,xi) - gradient
            %H(f,xi) - hessian

            %in quasi-newton, instead of H we use A, which uses only first derivatives.
            %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)

            options = optimoptions(@fminunc,'Display','iter',...
                'Algorithm','quasi-newton','HessUpdate','steepdesc',...
                'MaxIterations',maxIters,...
                'StepTolerance',StepTolerance);
            [x,fval,exitflag,output] = fminunc(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;
        end
        function [x,fval,exitflag,iterations,funcCount] = QuasiNewton(fun,x0,maxIters,StepTolerance)
        %we will use the BFGS quasi-newton method
        %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method
        
        %idea of newton's method:
        %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
        %D(f,xi) - gradient
        %H(f,xi) - hessian
        
        %in quasi-newton, instead of H we use A, which uses only first derivatives.
        %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)

        options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton',...
            'MaxIterations',maxIters,...
            'StepTolerance',StepTolerance);
        [x,fval,exitflag,output] = fminunc(fun,x0,options);
        iterations = output.iterations;
        funcCount = output.funcCount;
        end

        function [x,fval,exitflag,iterations,funcCount] = SimulatedAnealing(fun,x0,maxIters,FunctionTolerance)
            options = optimoptions('simulannealbnd','Display','iter',...
                'MaxIterations',maxIters,'FunctionTolerance',FunctionTolerance);
            
            [x,fval,exitflag,output] = simulannealbnd(fun,x0,[],[],options);
            iterations = output.iterations;
            funcCount = output.funccount;
        end

        function [x,fval,exitflag,generations,funcCount] = GeneticAlgorithm(fun,x0,MaxGenerations,FunctionTolerance,Npop)
            options = optimoptions('ga','Display','iter',...
                'MaxGenerations',MaxGenerations,'FunctionTolerance',FunctionTolerance,...
                'PopulationSize',Npop);

            nvars = length(x0);
            [x,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],[],[],[],options);
            generations = output.generations;
            funcCount = output.funccount;
        end

        function [x,fval,exitflag,iterations,funcCount] = DownhillSimplex(fun,x0,maxIters,StepTolerance) 
            %explination on the algorithm:
            %https://www.mathworks.com/help/optim/ug/fminsearch-algorithm.html
            options = optimset('Display','iter',...
                'TolX',StepTolerance,...
                'MaxIter',maxIters);

            [x,fval,exitflag,output] = fminsearch(fun,x0,options);
            iterations = output.iterations;
            funcCount = output.funcCount;
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
            
            methods = T.Properties.VariableNames;
            entries = T.Variables;
            shapes = {'o','+','*','x','s','d','p','h','^'};
            colors = jet(length(methods));
            for ii=1:length(methods)
                sols = cell2mat(entries(:,ii));
                z = fun(sols(:,1),sols(:,2)) + 1; %allow rendeer to show points above
                scatter3(ax,sols(:,1),sols(:,2),z,50,shapes{ii},...
                    'LineWidth',2,'MarkerEdgeColor',colors(ii,:));
            end
            legend([{funName},methods],'location','best');
            colorbar(ax);
            colormap(ax,'gray');

        end
    end
end