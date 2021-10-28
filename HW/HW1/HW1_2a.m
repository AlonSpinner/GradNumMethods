syms x y;
f = sin(x)*log(x*y);
poly1 = Taylor_fun(1,f,1,1);
poly2 = Taylor_fun(2,f,1,1);
poly3 = Taylor_fun(3,f,1,1);
fsurf(f,[0.5 1.5 0.5 1.5],'-r')
hold on 
fsurf(poly1,[0.5 1.5 0.5 1.5],'-b')
fsurf(poly2,[0.5 1.5 0.5 1.5],'-g')
fsurf(poly3,[0.5 1.5 0.5 1.5],'-m')
legend('exact','Taylor1','Taylor2','Taylor3','interpreter','latex')

function poly = Taylor_fun(n,f,point_x, point_y)
    syms x y
    poly = subs(subs(f,x,point_x),y,point_y);
    for i = 1:n
        poly = poly + Taylor_part_fun(1,i,f,point_x, point_y);
    end
end


function [poly] = Taylor_part_fun(j,n,f,point_x,point_y)
    syms x y
    if j > n
        poly = subs(subs(f,x,point_x),y,point_y);
    else
        poly = Taylor_part_fun(j+1,n,diff(f,x),point_x,point_y)/j*(x-point_x)+Taylor_part_fun(j+1,n,diff(f,y),point_x,point_y)/j*(y-point_y);
    end
end
