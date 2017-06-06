function [fOr,phi] = getOrInner(formula,k)

global x Z zLoop ZLoop bigM;

% number of agents
N = length(x);
% time horizon
h = size(x{1},2)-1;

% m*N binvar: a binary variable for each argument and agent 
z = [];

% Constraints
fOr = [];

% number of arguments
m = length(formula.args);
z =[];
fOr = [];

for i=1:m
    % Get its constraints
    [fLTL,phiLTL] = getLTL(formula.args{i},k);
    fOr = [fOr, fLTL];
    z = [z; phiLTL];
end

if m > 1
    % a binary variable for each agent
    phi = getZ(formula.formula,k,N);
    % conjunction constraint
    for n = 1:N
        fOr = [fOr, repmat(phi,m,1)>=z(:,n), phi(n)<=sum(z(:,n))];
    end
else
    phi = z;
end