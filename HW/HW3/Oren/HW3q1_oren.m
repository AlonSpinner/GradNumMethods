l = [330, 88, 400, 40, 405]';
points = {};
points{1} = [500, 0, 500]';
points{2} = [700, 500, 400]';
points{3} = [700, 500, 600]';
solutions = {zeros(4,3),zeros(4,3),zeros(4,3)};
sim_section = input('sim_section: ')
plt_run = input('plt_run: ')
n_min = 2
if (sim_section == 1)
    n = 20;
    TEqualy_grid1 = 0:2*pi/n:2*pi-2*pi/n;
    TEqualy_grid2 = TEqualy_grid1
    TEqualy_grid3 = TEqualy_grid1
elseif(sim_section == 2)
  n = n_min;
  TEqualy_grid1 = 0:2*pi/n:2*pi-2*pi/n;
  TEqualy_grid2 = TEqualy_grid1;
  TEqualy_grid3 = TEqualy_grid1;
else
  temp = 2*pi*rand(n_min,3);
  TEqualy_grid1 = temp(:,1)';
  TEqualy_grid2 = temp(:,2)';
  TEqualy_grid3 = temp(:,3)';
end
if(plt_run==1)
  sp_plot = zeros(8000,6,3);
end
  sp_num = 1
  runner = 1



options = optimset('Display','off');

for p = 1:3
    fun = @(T)ForwardKinematics(T) - points{p}'
    w = 1
    for i = TEqualy_grid1
        for j = TEqualy_grid2
            for k = TEqualy_grid3
                x0 = [i,j,k]';
                x = fsolve(fun,x0,options);
                if ((w == 1 || min(vecnorm(tan(solutions{p})-tan(x'),2,2)) > 10^-4) && norm(fun(x')) < 10^-2 && w~=5)
                solutions{p}(w,:) = mod(x,2*pi);
                w = w+1;
                end
                if (plt_run == 1)
                    if (min(vecnorm(solutions{p}-mod(x',2*pi),2,2)) < 10^-4)
                        [~,I] = min(vecnorm(solutions{p}-mod(x',2*pi),2,2));
                        if (I == 1)
                            color = [0,1,0];
                        elseif (I == 2)
                            color = [0,0,1];
                        elseif (I == 3)
                            color = [0,0,0];
                        elseif (I == 4)
                            color = [1,0,0];
                        end
                        sp_plot(runner,:,sp_num) = [i,j,k,color(1),color(2),color(3)];
                    else
                    sp_plot(runner,1:6,sp_num) = [i,j,k,1,1,0];
                    end
                    runner = runner + 1;
                end
            end
                if (w == 5 && plt_run ~= 1)
                    break
                end
            end
            if (w == 5 && plt_run ~= 1)
                break
            end
    end
        sp_num = sp_num + 1;
        runner = 1;
end
%%
    for (i = 1:3)
    colors = [[0,1,0];[0,0,1];[0,0,0];[1,0,0]]
    figure((sim_section-1)*3 + i)
    check_point = find(vecnorm(sp_plot(:,:,i),2,2) >10^-4)
    index = find(vecnorm(solutions{i},2,2)>10^-4)
    scatter3(solutions{i}(index,1),solutions{i}(index,2),solutions{i}(index,3),30*ones(size(index,1),1),colors(index,:),'filled')
    hold on
    scatter3(sp_plot(check_point,1,i),sp_plot(check_point,2,i),sp_plot(check_point,3,i),10*ones(size(check_point,1),1),sp_plot(check_point,4:6,i),'filled')
    xlabel('$$\Theta_{1}$$','Interpreter','latex')
    ylabel('$$\Theta_{2}$$','Interpreter','latex')
    zlabel('$$\Theta_{3}$$','Interpreter','latex')
    end