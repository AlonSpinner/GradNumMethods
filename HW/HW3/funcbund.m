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

            P=[X,Y,Z]';
            fP = matlabFunction(P,'vars',{[th1,th2,th3]'});

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
            fJ = matlabFunction(J,'vars',{[q(1),q(2),q(3)]'});
        end
        function solutions = findSolutions(x0s,ptargets,fP,errBound,fJ)
            ntargets = size(ptargets,2);
            
            if nargin > 4 %jacobian was provided
                Jflag=true;
                fsolveOptions = optimoptions('fsolve','SpecifyObjectiveGradient',true,'Display','off');
            else
                Jflag=false;
                fsolveOptions = optimoptions('Display','off');
            end
            
            solutions = cell(1,ntargets);
            for mm = 1:ntargets
                fPtarget = @(q) fP(q) - ptargets(:,mm);
                if Jflag
                    fPsoltarget = @(q) deal(fP(q) - ptargets(:,mm),fJ(q));
                else
                    fPsoltarget = fPtarget;
                end
                
                xsols=zeros(size(x0s));
                for ii=1:size(x0s,2)
                    xsols(:,ii) = wrapToPi(fsolve(fPsoltarget,x0s(:,ii),fsolveOptions));
                    disp(ii)
                end
                xsols_goodIdx = vecnorm(fPtarget(xsols),2,1)<errBound; %find solutions that pass criteria
                xsols_good = xsols(:,xsols_goodIdx);
                solutions{mm} = unique(round(xsols_good',4),'rows')'; %publish unique solutions
            end
            disp('finished finding solutions')
        end
        function x0Points = findx0Points4Solutions(x0s,solutions,ptargets,fP,errBound)
            fsolveOptions = optimset('Display','off');
            ntargets = size(ptargets,2);
            x0Points=cell(1,ntargets);
            for mm = 1:ntargets
                fPtarget = @(q) fP(q) - ptargets(:,mm);

                %initalize
                %if isempty(solutions{mm}), continue; end
                solAmnt = size(solutions{mm},2);
                x0Points_mm = cell(1,solAmnt+1); %+1 for no solution points
                for ii=1:solAmnt
                    x0Points_mm{ii} = solutions{mm}(:,ii);
                end

                %assign x0 points to each solution by distance of x from solution
                for ii=1:size(x0s,2)
                    x0 = x0s(:,ii);
                    x = wrapToPi(fsolve(fPtarget,x0,fsolveOptions));
                    if vecnorm(fPtarget(x),2)<errBound
                        [~,minIdx]=min(vecnorm(x-solutions{mm}));
                        x0Points_mm{minIdx}(:,end+1) = x0;
                    else
                        x0Points_mm{end}(:,end+1) = x0;
                    end

                    disp(ii)
                end

                x0Points{mm} = x0Points_mm;
                disp('finished assigning each x0 point to a solution')
            end
        end
        function PlotSolutions(solutions,x0Points)
            for mm=1:length(x0Points)
                %if isempty(solutions{mm}), continue; end

                fig=figure;
                ax=axes(fig);
                grid(ax,'on'); hold(ax,'on');
                xlabel(ax,'$$\Theta_{1}$$','Interpreter','latex');
                ylabel(ax,'$$\Theta_{2}$$','Interpreter','latex');
                zlabel(ax,'$$\Theta_{3}$$','Interpreter','latex');
                view(ax,3);
                
                %plot solutions
                solAmnt = size(solutions{mm},2);
                color = jet(solAmnt);
                for ii=1:solAmnt
                    XYZ = x0Points{mm}{ii}';
                    scatter3(ax,XYZ(1,1),XYZ(1,2),XYZ(1,3),200,color(ii,:),'filled','diamond',...
                        'MarkerEdgeColor',[0,0,0],'LineWidth',2);
                    scatter3(ax,XYZ(2:end,1),XYZ(2:end,2),XYZ(2:end,3),20,color(ii,:),'filled',...
                        'MarkerEdgeColor','none','MarkerFaceAlpha',0.5);
                end

                %plot not solutions
                XYZ = x0Points{mm}{end}';
                if ~isempty(XYZ)
                    scatter3(ax,XYZ(:,1),XYZ(:,2),XYZ(:,3),3,[0 0 0],"filled",...
                        'MarkerEdgeColor','none','MarkerFaceAlpha',0.5);
                end
            end
        end
    end
end