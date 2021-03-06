function [fNeg,phi] = getNeg(formula,args,k)

global Mw Z zLoop ZLoop bigM epsilon;

if length(args)>1
    disp('Negation takes a single argument');
    assert(length(args)==1);
end

fNeg = [];

if ischar(args{1}) % If argument is a formula
    % Get its constraints
    [fAP,z] = getLTL(args{1},k);
    fNeg = [fNeg, fAP];

else % if argument is counting proposition
    % sdpvar
    z = getZ(args{1},k);
    % state
    wi = args{1}(1:end-1);
    % threshold
    mi = args{1}(end);
    % number of states
    n = length(Mw{k});
    % constraint
    W = Mw{k}*ones(n,1);
    fNeg = [fNeg, sum(W(wi))>=mi+epsilon-bigM*(1-z)];
    fNeg = [fNeg, sum(W(wi))<=mi-epsilon+bigM*z-1];
end

% a binary variable for formula
phi = getZ(formula,k);

% Negation constaint
fNeg = [fNeg, phi == 1-z];