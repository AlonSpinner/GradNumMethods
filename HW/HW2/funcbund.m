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

        function P = randPerm(n)
            P = eye(n);
            P = P(randperm(n),:);
        end

        function detP = detPerm(P)
            % detP  = (-1)^t when t is the number of row switches

            %from some reference Noah Paul gave me:
            % the total number of swaps performed by a permutation matrix is given by the sum over all
            % rows of the number of 1s in subsequent rows that are to the left of the 1 in each row.

            n = funcbund.checkSquared(P);
            t=0;
            for ii=1:n
                [~,kk] = max(P(ii,:));
                t=t+sum(P(ii+1:end,1:kk),'all');
            end
            detP=(-1)^t;

            %         % OLD VERSION
            %         t=0;
            %         tmpP = P;
            %         for ii=1:n
            %             if tmpP(ii)==0
            %                 [~,jj] = max(tmpP(ii,:));
            %                 vTemp = tmpP(ii,:);
            %                 tmpP(ii,:) = tmpP(jj,:);
            %                 tmpP(jj,:) = vTemp;
            %
            %                 t = t+1;
            %             end
            %         end
            %         detP = (-1)^t;
        end
        
        function  [G,c] = prepGausSiedel(A,b)
            L = -tril(A,-1);
            D = diag(diag(A));
            Q = D-L;
            G = funcbund.InverseL(Q) * (Q-A);
            c = funcbund.InverseL(Q) * b;
        end

        function  [G,c] = prepJacobi(A,b)
            D = diag(diag(A));
            G = (1./D) * (D-A);
            c = (1./D) * b;
        end

        function x  = iterative_solver(G,c,x0,k)
            x=x0;
            for ii=1:k
                x = G*x + c;
            end
        end
    end
end