classdef funcbund
    methods(Static)
        function [P,fP] = symForwardKinematics()
            l1=330;
            l2=88;
            l3=400;
            l4=40;
            l5=405;

            syms th1 th2 th3 real
            c1 = cos(th1);
            s1 = sin(th1);
            c2 = cos(th2);
            s2 = sin(th2);
            c23 = cos(th2+th3);
            s23 = sin(th2+th3);

            X = c1*(l2+s2*l3+s23*l4+c23*l5);
            Y = s1*(l2+s2*l3+s23*l4+c23*l5);
            Z = l1 +c2*l3+c23*l4-s23*l5;

            P=[X,Y,Z];
            fP = matlabFunction(P);

        end

        function [J,fJ] = symJacobian()
            P = funcbund.symForwardKinematics();
            q = symvar(P);
            J = sym(zeros(3,3));
            for ii=1:size(J,1)
                for jj=1:size(J,2)
                    J(ii,jj) = diff(P(ii),q(jj));
                end
            end 
            fJ = matlabFunction(J);
        end
    end
end