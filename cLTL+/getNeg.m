function [fNeg,phi] = getNeg(formula,args,k)

global W Wtotal Z zLoop ZLoop bigM epsilon;

if length(args)>1
    disp('Negation takes a single argument');
    assert(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

% Get its constraints
[fNeg,z] = getLTL(args{1},k);

% a binary variable for formula
phi = getZ(formula,h,1);
phi = phi(k);

% Negation constaint
fNeg = [fNeg, phi == 1-z];