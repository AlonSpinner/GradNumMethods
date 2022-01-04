%% gaussian noise
% N=100;
% x=linspace(0,3*pi,N)'; %col
% Anoise = 0.4;
% noise = Anoise*randn(N,1); %col
y=cos(x) + noise;
%%
y1 = y;
y1(25:40) = y1(25:40) + 2;

%% RANSAC
sampleSize = 3; % number of points to sample per trial
maxDistance = 0.6; % max allowable distance for inliers
points = [x,y1];

sineFitType = fittype('a1*sin(a2*x+a3)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'a1','a2','a3'});
fitFcn = @(points) fit(points(:,1),points(:,2),sineFitType);
distFcn = @(model, points) sum((points(:, 2) - model(points(:,1))).^2,2);

[modelRANSAC, inlierIdx] = ransac(points,fitFcn,distFcn, ...
  sampleSize,maxDistance);

c = lines(1);
figure
scatter(x,y1,20,'black','filled');
hold on; grid on;
plot(x,modelRANSAC(x),'linewidth',2,'color',c);
xlabel('x'); ylabel('y')
legend('y1 vs x','Fit')