classdef funcbund
    properties(Constant)
    end
    methods(Static)
        function [x,fval,exitflag,iterations,funcCount] = QuasiNewton(fun,x0)
        %we will use the BFGS quasi-newton method
        %good stuff: https://en.wikipedia.org/wiki/Quasi-Newton_method
        
        %idea of newton's method:
        %x_ip1 = x_i - inv(H(f,xi))*D(f,xi)
        %D(f,xi) - gradient
        %H(f,xi) - hessian
        
        %in quasi-newton, instead of H we use A, which uses only first derivatives.
        %apprently MATLAB implements BFGS in fminunc (confirmed via documentation)
        
        options = optimoptions(@fminunc,'Display','iter','Algorithm','quasi-newton');
        [x,fval,exitflag,output] = fminunc(fun,x0,options);
        iterations = output.iterations;
        funcCount = output.funcCount;
        end

        function [x,fval,exitflag,iterations,funcCount] = SimulatedAnealing(fun,x0)
            options = optimoptions('simulannealbnd','Display','iter');
            
            [x,fval,exitflag,output] = simulannealbnd(fun,x0,[],[],options);
            iterations = output.iterations;
            funcCount = output.funccount;
        end

        function [x,fval,exitflag,generations,funcCount] = GeneticAlgorithm(fun,x0)
            options = optimoptions('ga','Display','iter');

            nvars = length(x0);
            [x,fval,exitflag,output,population,scores] = ga(fun,nvars,[],[],[],[],[],[],[],options);
            generations = output.generations;
            funcCount = output.funccount;
        end
    end
end