classdef funcbund
    properties(Constant)
        l1 = 1;
        l2 = 1;
        m1 = 1;
        m2 = 0.5;
        g = 1;
        wallX = -0.5;
        TolWallX=1e-8;
        h = 0.01; %default
        time_span = [0 10] %default
    end
    methods(Static)
        function fdy = createMyDoublePendulum()
            %y = [th1,th2,dth1,dth2]'
            %dy = [dth1,dth2,ddth1,ddth1]'
            %dy = My_DoublePendulum(t,y) = My_DoublePendulum(~,y) as t is
            %not relevant in equations

           m1 = funcbund.m1; 
           m2 = funcbund.m2; 
           l1 = funcbund.l1; 
           l2 = funcbund.l2; 
           g = funcbund.g;
            
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

        function [hLine1,hLine2,hEdge1,hEdge2] = plotPendulum(ax,th1,th2,varargin)            
            color = [0 0 0]; linestyle='-'; plotEdges = false;
            for ind=1:2:length(varargin)
                comm=lower(varargin{ind});
                switch comm
                    case 'color'
                        color=varargin{ind+1};
                    case 'linestyle'
                        linestyle=varargin{ind+1};
                    case 'plotedges'
                        plotEdges=varargin{ind+1};
                    otherwise
                        error('no such name-value pair exists');
                end
            end
            p = funcbund.theta2p([th1,th2]);
            hLine1 =plot(ax,[0,p(1,1)],[0,p(1,2)],...
                'linewidth',2,'linestyle',linestyle,'color',color);
            hLine2 = plot(ax,[p(1,1),p(2,1)],[p(1,2),p(2,2)],...
                'linewidth',2,'linestyle',linestyle,'color',color,...
                'Marker','o','MarkerFaceColor',color,'MarkerSize',15);
            if plotEdges
                hEdge1 = plot(ax,p(1,1),p(1,2),...
                    'linewidth',1,'linestyle',':','color','r');
                hEdge2 = plot(ax,p(2,1),p(2,2),...
                    'linewidth',1,'linestyle',':','color','b');
            end
        end

        function updatedPlotPendulum(hLine1,hLine2,th1,th2,hEdge1,hEdge2)
            p = funcbund.theta2p([th1,th2]);
            hLine1.XData = [0,p(1,1)]; hLine1.YData = [0,p(1,2)];
            hLine2.XData = [p(1,1),p(2,1)]; hLine2.YData =[p(1,2),p(2,2)];
            if nargin > 4
                hEdge1.XData = [hEdge1.XData,p(1,1)]; hEdge1.YData = [hEdge1.YData,p(1,2)];
                hEdge2.XData = [hEdge2.XData,p(2,1)]; hEdge2.YData = [hEdge2.YData,p(2,2)];
                uistack([hEdge1,hEdge2],'top');
            end

            uistack([hLine1,hLine2],'top');
        end

        function [ax,fig] = prepAxes(varargin)
            wall = false;
            for ind=1:2:length(varargin)
                comm=lower(varargin{ind});
                switch comm
                    case 'wall'
                        wall=varargin{ind+1};
                    otherwise
                        error('no such name-value pair exists');
                end
            end

            fig=figure('color',[1,1,1]);
            ax = axes(fig);
            hold(ax,'on')
            xlabel(ax,'x'); ylabel(ax,'y');
            grid(ax,'on');
            axis(ax,'equal');

            plot(ax,[-0.3,0.3],[0,0],'linestyle','--','Color',[0 0 0],'linewidth',2); %plot ceiling
            if wall
                plot(ax,[-0.5,-0.5],[0,-2],'linestyle','--','Color',[0 0 0],'linewidth',2); %plot ceiling
            end

        end
        function J = f5a(th)
            [~,y] = MY_RK4_event(@My_DoublePendulum, funcbund.h, funcbund.time_span, [th(1),th(2),0,0]');
            p = funcbund.theta2p(y(end,1:2));
            J = [p(1,1)-funcbund.wallX;
                p(2,1)-funcbund.wallX];
        end
        function J = f5b(th)
            [~,y] = MY_RK4_event(@My_DoublePendulum, funcbund.h, funcbund.time_span, [1,th,0,0]');
            p = funcbund.theta2p(y(end,1:2));
            J = p(1,1)-funcbund.wallX;
        end
        function J = f5c(th)
            [~,y] = MY_RK4_event(@My_DoublePendulum, funcbund.h, funcbund.time_span, [1,th,0,0]');
            p = funcbund.theta2p(y(end,1:2));
            J = p(2,1)-funcbund.wallX;
        end
        function p = theta2p(th)
            %-pi/2 for coordiante system
            x1 = funcbund.l1*cos(th(1)-pi/2); 
            y1 = funcbund.l1*sin(th(1)-pi/2); 
            x2 = x1 + funcbund.l2*cos(th(2)-pi/2);
            y2 = y1 + funcbund.l2*sin(th(2)-pi/2);
            p=[x1 y1;
                x2 y2];
        end
    end
end