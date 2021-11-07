classdef funcbund
    methods(Static)
        function n = checkSquared(M)
            n1 = size(M,1);
            n2 = size(M,2);
            if n1 ~= n2, error('matrix is not squared'); end
            n = n1;
        end

        function invU = InverseU(U)
            if ~istriu(U), error('not upper triangular'); end
            %invU * U = I

            n = size(U,1);
            I = eye(n);
            invU = zeros(n);
            for ii=n:-1:1
                b = I(:,ii);
                invU(:,ii) = funcbund.solveUy(U,b);
            end
        end

        function y=solveUy(U,b)
            if ~istriu(U), error('not upper triangular'); end
            n = size(U,1);
            y = zeros(n,1);

            y(n) = b(n)/U(n,n);
            for ii = n-1:-1:1
                y(ii) = (b(ii) - U(ii,ii+1:n)*y(ii+1:n)) / U(ii,ii);
            end
        end

        function x=solveLx(L,b)
            if ~istril(L), error('not lower triangular'); end
            n = size(L,1);
            x = zeros(n,1);

            x(1) = b(1)/L(1,1);
            for ii = 2:n
                x(ii) = (b(ii) - L(ii,1:ii-1)*x(1:ii-1)) / L(ii,ii);
            end
        end

        function invL = InverseL(L)
            if ~istril(L), error('not lower triangular'); end
            %invU * U = I

            n = size(L,1);
            I = eye(n);
            invL = zeros(n);
            for ii=1:n
                b = I(:,ii);
                invL(:,ii) = funcbund.solveLx(L,b);
            end
        end
    end
end