function [fGF,phi] = getGFOuter(formula, args, k)

global x u Z zLoop ZLoop bigM epsilon;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

z = [];
fGF = [];

formulaOr = strcat('Or(', ...
        num2str(formula.args{1}.formula),', (1-ZLoop))');
zOr = getZ(formulaOr, 1, h);   
% zAnd = binvar(h,1);
% Z{length(Z)+1} = {zAnd,formulaAnd};

for k = 1:h
    [fLTL,zk] = getLTL(formula.args{1}, k);
    z = [z;zk];
    fGF = [fGF, fLTL];
    % zAnd_k = And(z_k,ZLoop_k)
    fGF = [fGF, zOr(k)>=z(k), zOr(k)>=ZLoop(k), zOr(k)<=ZLoop(k)+z(k)];
end

phi = getZ(formula,1,1);

fGF = [fGF, repmat(phi,h,1)<=zOr, phi>=sum(zOr)-h+1];

    