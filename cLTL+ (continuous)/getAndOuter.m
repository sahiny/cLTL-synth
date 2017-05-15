function [fAnd,phi] = getAndOuter(formula,k)

global x Z zLoop ZLoop bigM;
% number of agents
N = length(x);
% number of states
I = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fAnd = [];

% number of arguments
m = length(formula.args);

for i=1:m
    % Get its constraints
    [fAP,phiAP] = getLTL(formula.args{i},k);
    fAnd = [fAnd, fAP];
    z = [z; phiAP];
end

if m > 1
    % a binary variable
    phi = getZ(formula.formula,k,1);
    % conjunction constraint
    fAnd = [fAnd, repmat(phi,m,1)<=z, phi>=1-m+sum(z)];
else
    phi = z;
end