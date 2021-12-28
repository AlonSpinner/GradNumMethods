model = createpde('thermal','transient');
width = 2; 
height = 2;
gdm = [3 4 0 width width 0 0 0 height height]';
g = decsg(gdm);
geometryFromEdges(model,g);
figure; 
pdegplot(model,'EdgeLabels','on'); 
axis([-.1 2.1 -.1 2.1]);
title 'Geometry With Edge Labels Displayed';
thermalProperties(model,'ThermalConductivity',2,'MassDensity',1,'SpecificHeat',1);
generateMesh(model);
tlist = 0:0.001:0.73
thermalIC(model,0);
thermalBC(model,'Edge',4,'HeatFlux',0) 

thermalBC(model,'Edge',3,'Temperature',1) 
outerCC = @(location,~) location.x*(2-location.x)
thermalBC(model,'Edge',1,'Temperature',outerCC) 
outerCC = @(location,~) 2-location.y
thermalBC(model,'Edge',2,'Temperature',outerCC) 
thermalresults = solve(model,tlist);
T = thermalresults.Temperature;
pdeplot(model,'XYData',T(:,end))