function [fTP,phi] = getTCP(formula, k)

global x Z zLoop ZLoop bigM;

assert(strcmp(formula.Op, 'TCP'), 'tcp required');

% number of agents
N = length(x);
% time horizon
h = size(x{1},2)-1;

[fTP, z] = getLTL(formula.phi,k);
phi = getZ(formula.formula,k,1);

fTP = [fTP, sum(z) >= formula.m - (N+1)*(1-phi)];
fTP = [fTP, sum(z) <= formula.m + (N+1)*phi - 1];
