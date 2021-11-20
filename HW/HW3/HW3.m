%% Prep
ntargets=3;
p1 = [500 0 500]';
p2 = [700 500 400]';
p3 = [700 500 600]';
ptargets = [p1,p2,p3];

errBound = 1e-4;
[~,fP] = funcbund.symForwardKinematics();
[~,fJ] = funcbund.symJacobian();
%% Q1
N=20;
[q1,q2,q3] = deal(linspace(-pi,pi,N));
% solutions = findSolutions(q1,q2,q3,ptargets,fP,errBound);
% x0Points = findx0Points4Solutions(q1,q2,q3,solutions,ptargets,fP,errBound);
PlotSolutions(solutions,x0Points);
%% Q1
function solutions = findSolutions(q1,q2,q3,ptargets,fP,errBound)

fsolveOptions = optimset('Display','off');
N = length(q1);
ntargets = size(ptargets,2);
solutions = cell(1,ntargets);
for mm = 1:ntargets
    xsols = cell(N,N,N);
    fPtarget = @(q) fP(q) - ptargets(:,mm);
    for ii = 1:N
        for jj = 1:N
            for kk = 1:N
                 x0 = [q1(ii),q2(jj),q3(kk)]';
                 xsols{ii,jj,kk} = wrapToPi(fsolve(fPtarget,x0,fsolveOptions));
                 disp(kk+(jj-1)*N+(ii-1)*N^2); %iteration count
            end
        end
    end
    xsols_goodIdx = cellfun(@(x) vecnorm(fPtarget(x),2)<errBound,xsols); %find solutions that pass criteria
    xsols_good = cell2mat(xsols(xsols_goodIdx)')';%convert to Mx3 matrix
    solutions{mm} = unique(round(xsols_good,4),'rows')'; %publish unique solutions
end
end

function x0Points = findx0Points4Solutions(q1,q2,q3,solutions,ptargets,fP,errBound)
fsolveOptions = optimset('Display','off');
N = length(q1);
ntargets = size(ptargets,2);
x0Points=cell(1,3);
for mm = 1:ntargets
    fPtarget = @(q) fP(q) - ptargets(:,mm);
    
    %initalize
    if isempty(solutions{mm}), continue; end
    solAmnt = size(solutions{mm},2);
    x0Points_mm = cell(1,solAmnt);
    for ii=1:solAmnt
        x0Points_mm{ii} = solutions{mm}(:,ii);
    end
    
    %assign x0 points to each solution by distance of x from solution
    for ii = 1:N
        for jj = 1:N
            for kk = 1:N
                 x0 = [q1(ii),q2(jj),q3(kk)]';
                 x = wrapToPi(fsolve(fPtarget,x0,fsolveOptions));
                 if vecnorm(fPtarget(x),2)<errBound
                    [~,minIdx]=min(vecnorm(x-solutions{mm}));
                    x0Points_mm{minIdx}(:,end+1) = x0;
                 end
                 disp(kk+(jj-1)*N+(ii-1)*N^2); %iteration count
            end
        end
    end
    
    x0Points{mm} = x0Points_mm;
end
end
%% Q1 plot
function PlotSolutions(solutions,x0Points)
for mm=1:length(x0Points)
    if isempty(solutions{mm}), continue; end
    
    fig=figure;
    ax=axes(fig);
    grid(ax,'on'); hold(ax,'on');
    xlabel(ax,'$$\Theta_{1}$$','Interpreter','latex');
    ylabel(ax,'$$\Theta_{2}$$','Interpreter','latex');
    zlabel(ax,'$$\Theta_{3}$$','Interpreter','latex');
    view(ax,3);
    
    solAmnt = size(solutions{mm},2);
    color = lines(solAmnt);
    for ii=1:solAmnt
        XYZ = x0Points{mm}{ii}';
        scatter3(ax,XYZ(1,1),XYZ(2,2),XYZ(3,3),200,color(ii,:),'filled','diamond');
        scatter3(ax,XYZ(2:end,1),XYZ(2:end,2),XYZ(2:end,3),20,color(ii,:),'filled',...
            'MarkerEdgeColor','none','MarkerFaceAlpha',0.5);
    end
end
end