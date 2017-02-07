function [fFG,phi] = getFG(formula, args, k)

global Mw ZLoop;

if length(args)>1
    disp('GF takes a single argument')
    return
end

% number of states
n = length(Mw{1});

% time horizon
h = length(Mw);

phi = getZ(formula, 1);

ZOr = [];
z = [];
fFG = [];
for i = 1:h
    [fLTL,zi] = getLTL(args{1}, i);
    z = [z;zi];
    fFG = [fFG, fLTL];
    % Zi = Or(zi,1-ZLoop)
    formula = strcat('Or(', ...
        num2str(args{1}), '[', num2str(i), '],',...
        '(1-ZLoop)[', num2str(i), '])');
    zOr = getZ(formula, -1);
    ZOr = [ZOr; zOr];
    fFG = [fFG, zOr>=z(i), zOr>=1-ZLoop(i), zOr<=1-ZLoop(i)+z(i)];
    
end

fFG = [fFG, repmat(phi,h,1)<=ZOr, phi>=1-h+sum(ZOr)];

    