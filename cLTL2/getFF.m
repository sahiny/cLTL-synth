function [fFF,phi] = getFF(formula, args, k)

global Mw Z;

if length(args)>1
    disp('FF takes a single argument');
    asset(length(args)==1);
end

% number of states
n = length(Mw{1});

% time horizon
h = length(Mw);

z = [];
fFF = [];
for i = 1:h
    [fLTL,zi] = getLTL(args{1}, i);
    z = [z;zi];
    fFF = [fFF, fLTL];  
end

phi = getZ(formula, 1);

fFF = [fFF, repmat(phi,h,1)>=ZOr, phi<=sum(ZOr)];

    