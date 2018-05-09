function [fGFI,phi] = getGFInner(formula, k)

assert(length(formula.args)==1, 'GF takes a single argument');

global u x Z ZLoop tau;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(u{1},2);

z = [];
fGFI = [];

formulaAnd = strcat('And(', formula.formula, ', ZLoop)');
ZAnd = [];
for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k);
    z = [z;zLTL];
    fGFI = [fGFI, fLTL];
    zAnd = getZ(formulaAnd,k,N);
    ZAnd = [ZAnd;zAnd];
    for n = 1:N  
        fGFI = [fGFI, ZAnd(k,n)<=z(k,n), ZAnd(k,n)<=ZLoop(k), ZAnd(k,n)>=ZLoop(k)+z(k,n)-1];
    end
end

phi = getZ(formula.formula, 1, N);

for n = 1:N
   fGFI = [fGFI, repmat(phi(n),h,1)>=ZAnd(:,n), phi(n)<=sum(ZAnd(:,n))];
end

    