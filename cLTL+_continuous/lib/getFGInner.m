function [fFGI,phi] = getFGInner(formula, k, S)


global u x Z ZLoop tau;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(u{1},2);

if strcmp(formula.type, 'ap')
    formula.args = {formula};
end
assert(length(formula.args)==1, 'GF takes a single argument');

z = [];
fFGI = [];

formulaOr = strcat('And(', formula.formula, ', (1-ZLoop))');
ZOr = getZ(formulaOr,h,N);
for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k, S);
    z = [z;zLTL];
    fFGI = [fFGI, fLTL];
    for n = S 
        fFGI = [fFGI, ZOr(k,n)>=z(k,n), ZOr(k,n)>=1-ZLoop(k), ZOr(k,n)<=1-ZLoop(k)+z(k,n)];
    end
end

phi = getZ(formula.formula, 1, N);

for n = S
   fFGI = [fFGI, repmat(phi(n),h,1)<=ZOr(:,n), phi(n)>=1-h+sum(ZOr(:,n))];
end