%% Prep
ntargets=3;
p1 = [500 0 500]';
p2 = [700 500 400]';
p3 = [700 500 600]';
ptargets = [p1,p2,p3];

errBound = 1e-4;
[~,fP] = funcbund.symForwardKinematics();
[~,fJ] = funcbund.symJacobian();
%% Q1.1
N=20;
[q1,q2,q3] = deal(linspace(-pi,pi,N));
x0s = zeros(3,N^3);
for ii = 1:N
    for jj = 1:N
        for kk = 1:N
            x0s(:,kk+(jj-1)*N+(ii-1)*N^2) = [q1(ii),q2(jj),q3(kk)]';
        end
    end
end

solutions = funcbund.findSolutions(x0s,ptargets,fP,errBound);
x0Points = funcbund.findx0Points4Solutions(x0s,solutions,ptargets,fP,errBound);
funcbund.PlotSolutions(solutions,x0Points,'Q1.1');
%% Q1.2
N=3;
[q1,q2,q3] = deal(linspace(-pi,pi,N));
x0s = zeros(3,N^3);
for ii = 1:N
    for jj = 1:N
        for kk = 1:N
            x0s(:,kk+(jj-1)*N+(ii-1)*N^2) = [q1(ii),q2(jj),q3(kk)]';
        end
    end
end

solutions = funcbund.findSolutions(x0s,ptargets,fP,errBound);
x0Points = funcbund.findx0Points4Solutions(x0s,solutions,ptargets,fP,errBound);
funcbund.PlotSolutions(solutions,x0Points,'Q1.2');
%% Q1.3
N=3^3;
x0s = wrapToPi(2*pi*rand(3,N));

solutions = funcbund.findSolutions(x0s,ptargets,fP,errBound);
x0Points = funcbund.findx0Points4Solutions(x0s,solutions,ptargets,fP,errBound);
funcbund.PlotSolutions(solutions,x0Points, 'Q1.3');

%% Q2.1
J = funcbund.symJacobian();
pretty(J);

%% Q2.2
N=20;
[q1,q2,q3] = deal(linspace(-pi,pi,N));
x0s = zeros(3,N^3);
for ii = 1:N
    for jj = 1:N
        for kk = 1:N
            x0s(:,kk+(jj-1)*N+(ii-1)*N^2) = [q1(ii),q2(jj),q3(kk)]';
        end
    end
end

tic
funcbund.findSolutions(x0s,p1,fP,errBound,fJ); %with Jacobian
disp('with Jacobian:')
toc

tic
funcbund.findSolutions(x0s,p1,fP,errBound); %without Jacobian
disp('without Jacobian:')
toc