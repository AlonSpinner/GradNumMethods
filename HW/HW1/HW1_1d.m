P0=[0.5,0.5];
P=rand(10,2);
R=MyDist_a(P,P0);

fig=figure('color',[1,1,1]);
ax=axes(fig);
hold(ax,'on'); grid(ax,'on');
scatter(ax,P0(:,1),P0(:,2),50,'filled','color','black');
scatter(ax,P(:,1),P(:,2),50,'filled','color','blue');
ylabel(ax,'y[-]');
xlabel(ax,'x[-]');

for ii=1:length(R)
    Pii=P(ii,:);
%     v=Pii-P0;
%     vhat=v/vecnorm(v);
%     Qii=P0+vhat*R(ii)/2;
    Qii=(Pii-P0)/2+P0;
    plot(ax,[P0(1),Pii(1)],[P0(2),Pii(2)],'linewidth',0.5,'color','g');
    text(ax,Pii(1),Pii(2),sprintf('P_{%g}',ii),'FontSize',14);
    text(ax,Qii(1),Qii(2),sprintf('R_{%g}=%.2g',ii,R(ii)),'FontSize',10);
end

