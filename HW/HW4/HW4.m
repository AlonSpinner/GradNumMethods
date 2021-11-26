%% Q2
y0 = [pi/4,1,0,0]';
time_span = [0 10];
h= fliplr([0.01,0.05,0.1,0.5,1]);
yfinal = zeros(length(y0),length(h));
for ii = 1:length(h)
    [~,y] = MY_RK4('My_DoublePendulum', h(ii), time_span, y0);
    yfinal(:,ii) = y(end,:)';
end

%plotting
ax = funcbund.prepAxes();
colors = winter(length(h));
h4legend = gobjects(1,length(h)+1);
legendTxt = cell(1,length(h)+1);
[~,h4legend(1)] = funcbund.plotPendulum(ax,y0(1),y0(2),'color',[0 0 0]);
legendTxt{1} = sprintf('initial condition');
for ii = 1:length(h)
    [~,h4legend(ii+1)] = funcbund.plotPendulum(ax,yfinal(1,ii),yfinal(2,ii),'color',colors(ii,:));
    legendTxt{ii+1} = sprintf('h = %.2g',h(ii));
end
legend(ax,h4legend,legendTxt)

%% Q2 - make Video
y0 = [pi/4,1,0,0]';
time_span = [0 10];
h = 0.01;
[t,y] = MY_RK4('My_DoublePendulum', h, time_span, y0);
vidWriter = VideoWriter('h1e-2','Motion JPEG AVI');
vidWriter.FrameRate = length(t)/t(end);
open(vidWriter);

ax = funcbund.prepAxes('wall',false);
colors = winter(length(t)+1);
htxt = text(ax,1.2,-0.2,sprintf('t = %.2g [s]',t(1)));
ax.YLim = [-2.1,0];
ax.XLim = [-2,2];
title(ax,'h = 1e-2, y0 = [pi/4,1,0,0]');

[hLine1,hLine2] = funcbund.plotPendulum(ax,y0(1),y0(2));
for ii=1:length(t)
    funcbund.plotPendulum(ax,y(ii,1),y(ii,2),'color',colors(ii,:));
    funcbund.updatedPlotPendulum(hLine1,hLine2,y(ii,1),y(ii,2));
    htxt.String = sprintf('t = %.4g [s]',t(ii));
    frame = getframe(ax);
    writeVideo(vidWriter,getframe(ax));
end
close(vidWriter);

%% Q3
h= 0.01;
y0 = [pi/4,1,0,0]';
time_span = [0 10];
[t,y] = MY_RK4_event('My_DoublePendulum', h, time_span, y0);

xs=zeros(length(t),2);
for ii=1:length(t)
    p =  funcbund.theta2p([y(ii,1),y(ii,2)]);
    xs(ii,:) = [p(1,1),p(2,1)];
end

ax = funcbund.prepAxes('wall',true);
htxt = text(ax,1.2,-0.2,sprintf('t = %.2g [s]',t(1)));
ax.YLim = [-2.1,0]; ax.XLim = [-2,2];
title(ax,'h = 1e-2, y0 = [pi/4,1,0,0], with wall');
vidWriter = VideoWriter('h1e-2wall','Motion JPEG AVI');
vidWriter.FrameRate = length(t)/t(end);
open(vidWriter);
[hLine1,hLine2,hEdge1,hEdge2] = funcbund.plotPendulum(ax,y0(1),y0(2),'plotEdges',true);
for ii=1:length(t)
    funcbund.updatedPlotPendulum(hLine1,hLine2,y(ii,1),y(ii,2),hEdge1,hEdge2);
    htxt.String = sprintf('t = %.4g [s]',t(ii));
    frame = getframe(ax);
    writeVideo(vidWriter,getframe(ax));
end
close(vidWriter);

fig = figure('color',[1,1,1]);
ax = axes(fig);
hold(ax,'on'); grid(ax,'on');
xlabel(ax,'t'); ylabel(ax,'x');
title(ax,'h = 1e-2, y0 = [pi/4,1,0,0], with wall');
h1 = plot(ax,t,xs(:,1));
h2 = plot(ax,t,xs(:,2));
h3 = plot(ax,ax.XLim,funcbund.wallX*[1,1],'linestyle','--','color','k');
legend(ax,[h1 h2 h3],{'x of m1', 'x of m2', 'x of wall'})