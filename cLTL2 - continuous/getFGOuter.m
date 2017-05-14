function [fFG,phi] = getFGOuter(formula, args, k)

global x u Z zLoop ZLoop bigM epsilon;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of agents
N = length(x);
% number of states
I = size(x{1},1);
% time horizon
h = size(x{1},2)-1;

z = [];
fFG = [];

formulaOr = strcat('Or(', ...
        num2str(formula.args{1}.formula),', (1-ZLoop))');
zOr = getZ(formulaOr, 1, h);   
% zAnd = binvar(h,1);
% Z{length(Z)+1} = {zAnd,formulaAnd};

for k = 1:h
    [fLTL,zk] = getLTL(formula.args{1}, k);
    z = [z;zk];
    fFG = [fFG, fLTL];
    % zAnd_k = And(z_k,ZLoop_k)
    fFG = [fFG, zOr(k)>=z(k), zOr(k)>=1-ZLoop(k), zOr(k)<=1-ZLoop(k)+z(k)];
end

phi = getZ(formula.formula,1,1);

fFG = [fFG, repmat(phi,1,h)<=zOr, phi>=sum(zOr)-h+1];

    