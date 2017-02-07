function [fGF,phi] = getGF(formula, args, k)

global Mw Z zLoop ZLoop bigM epsilon;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of states
n = length(Mw{1});

% time horizon
h = length(Mw);

ZAnd = [];
z = [];
fGF = [];
for i = 1:h
    [fLTL,zi] = getLTL(args{1}, i);
    z = [z;zi];
    fGF = [fGF, fLTL];
    % Zi = And(zi,ZLoop)
    formula = strcat('And(', ...
        num2str(args{1}), '[', num2str(i), '],',...
        'ZLoop[', num2str(i), '])');
    zAnd = getZ(formula, -1);
    ZAnd = [ZAnd; zAnd];
    fGF = [fGF, zAnd<=zi, zAnd<=ZLoop(i), zAnd>=ZLoop(i)+zi-1];
    
end

phi = getZ(formula, 1);

fGF = [fGF, repmat(phi,h,1)>=ZAnd, phi<=sum(ZAnd)];

    