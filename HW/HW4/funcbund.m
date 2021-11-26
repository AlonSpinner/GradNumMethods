classdef funcbund
    methods(Static)
        function fdy = createMyDoublePendulum(m1,m2,l1,l2,g)
            %y = [th1,th2,dth1,dth2]'
            %dy = [dth1,dth2,ddth1,ddth1]'
            %dy = My_DoublePendulum(t,y) = My_DoublePendulum(~,y) as t is
            %not relevant in equations

            if nargin == 0 % no inputs
                m1 = 1; m2 = 0.5; l1 = 1; l2 = 1; g = 1;
            end
            
            syms t th1 th2 dth1 dth2 ddth1 ddth2 real            
        
            %specify ODEs: 6 variables with 2 equations.
            %perfect, as to create dy given y, we need only to compute ddth1 and ddth2 
            eq1 = (m1+m2)*l1*ddth1 + m2*l2*ddth2*cos(th2-th1) == m2*l2*dth2^2*sin(th2-th1)-(m1+m2)*g*sin(th1);
            eq2 = l2*ddth2 + l1*ddth1*cos(th2-th1) == -l1*dth1^2*sin(th2-th1) - g*sin(th2);
            
            ddth1_updated = solve(eq1,ddth1); %ddth1 now function of th1,th2,dth2,ddth2
            eq2 = subs(eq2,ddth1,ddth1_updated);
            ddth2_updated = solve(eq2,ddth2); %ddth2 now function of th1,th2,dth1,dth2
            ddth1_updated2 = subs(ddth1_updated,ddth2,ddth2_updated); %ddth1 now function of th1,th2,dth1,dth2
            
            y = [th1,th2,dth1,dth2];
            dy = [dth1,dth2,ddth1_updated2,ddth2_updated]';
            
            txt = {'This function was created automatically from funcbund.createMyDoublePendulum',...
                'accepts column vectors and returns column vectors',...
                't is entered to allow function to be called in ODEsolvers even though its not used'};
            fdy = matlabFunction(dy,'File','My_DoublePendulum',...
                'vars',{t,y'},...
                'comments',txt);
        end

        function [hLine1,hLine2] = plotPendulum(ax,th1,th2,varargin)            
            
            l1 = 1; l2 = 1; color = [0 0 0];
            for ind=1:2:length(varargin)
                comm=lower(varargin{ind});
                switch comm
                    case 'l1'
                        l1=varargin{ind+1};
                    case 'l2'
                        l2=varargin{ind+1};
                    case 'color'
                        color=varargin{ind+1};
                    otherwise
                        error('no such name-value pair exists');
                end
            end

            P0 = [0,0]';
            P1 = P0 + [l1*cos(th1),l1*sin(th1)]';
            P2 = P1 + [l2*cos(th2),l2*sin(th2)]';
            
            R = rotz(-90);
            R = R(1:2,1:2);
            P1 = R*P1;
            P2 = R*P2;

            hLine1 =plot(ax,[P0(1),P1(1)],[P0(2),P1(2)],'linewidth',2,'color',color);
            hLine2 = plot(ax,[P1(1),P2(1)],[P1(2),P2(2)],'linewidth',2,'color',color,...
                'Marker','o','MarkerFaceColor',color,'MarkerSize',15);
        end

        function ax = prepAxes(QplotWall)
            fig=figure('color',[1,1,1]);
            ax = axes(fig);
            hold(ax,'on')
            xlabel(ax,'x'); ylabel(ax,'y');
            grid(ax,'on');
            axis(ax,'equal');

            plot(ax,[-0.3,0.3],[0,0],'linestyle','--','Color',[0 0 0],'linewidth',2); %plot ceiling
            if QplotWall
                plot(ax,[-0.5,-0.5],[0,-2],'linestyle','--','Color',[0 0 0],'linewidth',2); %plot ceiling
            end

        end
    end
end