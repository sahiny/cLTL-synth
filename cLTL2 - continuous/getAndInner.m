function [fAnd,phi] = getAndInner(formula,k)

global x Z zLoop ZLoop bigM;

% number of agents
N = length(x);
% time horizon
h = size(x{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fAnd = [];

% number of arguments
m = length(formula.args);
z =[];
fAnd = [];

for i=1:m
    % Get its constraints
    [fLTL,phiLTL] = getLTL(formula.args{i},k);
    fAnd = [fAnd, fLTL];
    z = [z; phiLTL];
end

if m > 1
    % a binary variable for each agent
    phi = getZ(formula.formula,k,N);
    % conjunction constraint
    for n = 1:N
        fAnd = [fAnd, repmat(phi,m,1)<=z(:,n), phi(n)>=1-m+sum(z(:,n))];
    end
else
    phi = z;
end