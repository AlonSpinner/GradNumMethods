%% Q2
N = 10;
f = @(x) (1+x.^2).^-1;

xgt = linspace(-5,5,10*N);
ygt = f(xgt);


xSamp = linspace(-5,5,N);
ySamp = f(xSamp);

xIntrp = xgt;
yIntrp = zeros(size(ygt));
for kk = 1:length(xIntrp)
    yIntrp(kk) = lagrange(xIntrp(kk),xSamp,ySamp);
end

fig = figure;
ax = axes(fig); hold(ax,'on'); grid(ax,'on');
plot(ax,xgt,ygt);
scatter(ax,xSamp,ySamp,'marker','o');
plot(ax,xIntrp,yIntrp);
legend('ground truth','interpolation points','interpolation');


function y=lagrange(x,pointx,pointy)
%
%LAGRANGE   approx a point-defined function using the Lagrange polynomial interpolation
%
%      LAGRANGE(X,POINTX,POINTY) approx the function definited by the points:
%      P1=(POINTX(1),POINTY(1)), P2=(POINTX(2),POINTY(2)), ..., PN(POINTX(N),POINTY(N))
%      and calculate it in each elements of X
%
%      If POINTX and POINTY have different number of elements the function will return the NaN value
%
%      function wrote by: Calzino
%      7-oct-2001
%
n=size(pointx,2);
L=ones(n,size(x,2));
if (size(pointx,2)~=size(pointy,2))
   fprintf(1,'\nERROR!\nPOINTX and POINTY must have the same number of elements\n');
   y=NaN;
else
   for i=1:n
      for j=1:n
         if (i~=j)
            L(i,:)=L(i,:).*(x-pointx(j))/(pointx(i)-pointx(j));
         end
      end
   end
   y=0;
   for i=1:n
      y=y+pointy(i)*L(i,:);
   end
end
end