function [state,options,optchanged] = ga_outputFcn_global(options,state,flag)
% outputFcn_global()
%
% OutputFun for optimizers (fminunc, fmincon etc),  saving intermediate results 
% in global variable "outputFcn_global_data" for later access. 
%
% It is not supposed for live updates during optimization but for 
% later inspection, which is much more efficient. 
%
% Usage 
%   options = optimoptions( ... , 'OutputFcn',@outputFcn_global ); 
%   [XOpt,fval,exitflag,output] = fminunc(@fun, X0, options); 
%   outputFcn_global_data(k).x 
%
% See also the supplied example file. 
%
% Last Changes
%   Daniel Frisch, ISAS, 10.2020: created example
%   Daniel Frisch, ISAS, 11.2019: improved documentation 
% Created
%   Daniel Frisch, ISAS, 10.2019 
%
optchanged = false;
global outputFcn_global_data
switch flag
  case 'init'
    outputFcn_global_data = struct();
    outputFcn_global_data.state = state;
  case 'iter'
    ind = length(outputFcn_global_data)+1;
    outputFcn_global_data(ind).state = state;
  case 'done'
    %
  otherwise
    error('wrong switch')
end
end
