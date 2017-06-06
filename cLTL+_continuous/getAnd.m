function [fAnd,phi] = getAnd(formula, k)

global x Z;

% time horizon
h = size(x{1},2)-1;

if strcmp(formula.type, 'tp')
    formula.args = {formula};
end

m = length(formula.args);

z = [];
fAnd = [];
for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k);
    z = [z;zLTL];
    fAnd = [fAnd, fLTL];
end

if m > 1
    % a binary variable
    phi = getZ(formula.formula,h,1);
    phi = phi(k);
    % conjunction constraint
    fAnd = [fAnd, repmat(phi,m,1)<=z, phi>=1-m+sum(z)];
else
    phi = z;
end
