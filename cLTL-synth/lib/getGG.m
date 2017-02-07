function [fGG,phi] = getGG(formula, args, k)

global Mw Z;

if length(args)>1
    disp('GG takes a single argument');
    asset(length(args)==1);
end

% number of states
n = length(Mw{1});

% time horizon
h = length(Mw);

z = [];
fGG = [];
for i = 1:h
    [fLTL,zi] = getLTL(args{1}, i);
    z = [z;zi];
    fGG = [fGG, fLTL];  
end

phi = getZ(formula, 1);

fGG = [fGG, repmat(phi,h,1)<=ZOr, phi>=1-h+sum(ZOr)];

    