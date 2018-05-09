function [fGF,phi] = getGFOuter(formula, args, k)

global x u Z zLoop ZLoop bigM col_radius tau;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of agents
N = length(x);
% number of states
I = size(x{1},1);
% time horizon
h = size(u{1},2);

z = [];
fGF = [];

formulaAnd = strcat('And(', ...
        num2str(formula.args{1}.formula),', ZLoop)');
zAnd = getZ(formulaAnd, 1, h);   
% zAnd = binvar(h,1);
% Z{length(Z)+1} = {zAnd,formulaAnd};

for k = 1:h
    [fLTL,zk] = getLTL(formula.args{1}, k);
    z = [z;zk];
    fGF = [fGF, fLTL];
    % zAnd_k = And(z_k,ZLoop_k)
    if k <= h
        fGF = [fGF, zAnd(k)<=z(k), zAnd(k)<=ZLoop(k), zAnd(k)>=ZLoop(k)+z(k)-1];
    end
end

phi = getZ(formula.formula,1,1);

fGF = [fGF, repmat(phi,1,h)>=zAnd, phi<=sum(zAnd)];

    