P0=[0.5,0.5];
logk=1:0.2:5;
k=10.^logk; %amount of points in Pk

[a,b]=deal(zeros(size(k)));
for ii=1:length(k)
    P=rand(round(k(ii)),2);
    tic;
    R=MyDist_a(P,P0);
    a(ii)=toc;
    
    tic;
    R=MyDist_b(P,P0);
    b(ii)=toc;
end

fig=figure('color',[1,1,1]);
ax=axes(fig);
hold(ax,'on'); grid(ax,'on');
scatter(ax,logk,a./b,50,'filled')
plot(ax,[logk(1),logk(end)],[1,1],'linewidth',3,'color','r');
ylabel(ax,'Calculation time rational: a/b');
xlabel(ax,'log(k) where k = number of points in P');
title(ax,'Comparing for Loop vs Vectorization for Euclid Distances')

