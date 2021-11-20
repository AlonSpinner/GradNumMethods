l = [330, 88, 400, 40, 405]';
points = {};
points{1} = [500, 0, 500]';
points{2} = [700, 500, 400]';
points{3} = [700, 500, 600]';
solutions = {zeros(4,3),zeros(4,3),zeros(4,3)};
n = 2;
Equaly_grid = -pi:2*pi/n:pi;
options = optimset('Display','off');

for p = 1:3
    fun = @(T)ForwardKinematics(T) - points{p}'
    w = 1
    for i = Equaly_grid
        for j = Equaly_grid
            for k = Equaly_grid
                x0 = [i,j,k]';
                x = fsolve(fun,x0,options);
                if ((w == 1 || (min(vecnorm(solutions{p}-wrapToPi(x'),2,2)) > 10^-4)) && norm(fun(x')) < 10^-2)
                solutions{p}(w,:) = wrapToPi(x);
                w = w+1;
                end
                if (w == 5)
                    break
                end
            end
            if (w == 5)
                break
            end
        end
        if (w == 5)
            break
        end
    end
end

function F = IK(T,P)
    Pos = ForwardKinematics(T);
    F = Pos-P;
    
end
