N=100;
x = linspace(1,5,N);
y = linspace(1,5,N);
zz = zeros(N);
[xx,yy] = meshgrid(x,y);
for ii=1:N
    for jj=1:N
        zz(ii,jj) = fEasom([x(ii),y(jj)]);
    end
end
surf(xx,yy,zz);