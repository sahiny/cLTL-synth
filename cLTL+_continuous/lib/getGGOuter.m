function [fGG,phi] = getGGOuter(formula, k)

global u x Z tau;

% number of agents
N = length(x);
% number of states
dx = size(x{1},1);
% time horizon
h = size(u{1},2);

if strcmp(formula.type, 'tp')
    formula.args = {formula};
end
assert(length(formula.args)==1, 'GG takes a single argument');

z = [];
fGG = [];


for k = 1:h
    [fLTL,zLTL] = getLTL(formula.args{1}, k);
    z = [z;zLTL];
    fGG = [fGG, fLTL];
end

phi = getZ(formula.formula, k, 1);
fGG = [fGG, repmat(phi,h,1)<=z, phi>=1-h+sum(z)];
