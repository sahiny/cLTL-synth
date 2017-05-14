function [fFFI,phi] = getFFI(formula, k)

global x Z zLoop ZLoop bigM;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

assert(length(formula.args)==1, 'GG takes a single argument');

z = [];
fFFI = [];

for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k);
    z = [z;zLTL];
    fFFI = [fFFI, fLTL];
end

phi = getZ(formula.formula, 1, N);

for n = 1:N
   fFFI = [fFFI, repmat(phi(n),h,1)>=z(:,n), phi(n)<=sum(z(:,n))];
end