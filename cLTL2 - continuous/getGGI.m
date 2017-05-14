function [fGGI,phi] = getGGI(formula, k)

global x Z zLoop ZLoop bigM;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

assert(length(formula.args)==1, 'GG takes a single argument');

z = [];
fGGI = [];

for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k);
    z = [z;zLTL];
    fGGI = [fGGI, fLTL];
end

phi = getZ(formula.formula, 1, N);

for n = 1:N
   fGGI = [fGGI, repmat(phi(n),h,1)<=z(:,n), phi(n)>=1-h+sum(z(:,n))];
end