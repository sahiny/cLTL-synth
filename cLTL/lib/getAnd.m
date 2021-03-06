function [fAnd,phi] = getAnd(formula,args,k)

global Mw Z zLoop ZLoop bigM epsilon;

% a binary variable for each argument
z = [];

% Constraints
fAnd = [];

% number of arguments
m = length(args);

for i=1:m
    if ischar(args{i}) % If argument is a formula
        % Get its constraints
        [fAP,phiAP] = getLTL(args{i},k);
        fAnd = [fAnd, fAP];
        z = [z;phiAP];
    else % if argument is counting proposition
        % sdpvar
        ztemp = [getZ(args{i},k)];
        z = [z;ztemp];
        % state
        wi = args{i}(1:end-1);
        % threshold
        mi = args{i}(end);
        % number of states
        n = length(Mw{k});
        % constraint
        W = Mw{k}*ones(n,1);
        fAnd = [fAnd, sum(W(wi))>=mi+epsilon-bigM*(1-z(i))];
        fAnd = [fAnd, sum(W(wi))<=mi-epsilon+bigM*z(i)-1];
    end
end

if m > 1
    % a binary variable for formula
    phi = getZ(formula,k);
    % conjunction constraint
    fAnd = [fAnd, repmat(phi,m,1)<=z, phi>=1-m+sum(z)];
else
    phi = z;
end