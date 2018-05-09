function [fNeg,phi] = getNegI(formula,args,k)

global W Wtotal Z zLoop ZLoop bigM epsilon tau;

if length(args)>1
    disp('Negation takes a single argument');
    assert(length(args)==1);
end

% number of agents
N = length(W);
% time horizon
h = size(W{1},2)-1-tau;

% Constraints
fNeg = [];

if ischar(args{1}) % If argument is a formula
    % Get its constraints
    [fAP,z] = getLTL(args{1},k);
    fNeg = [fNeg, fAP];
else % if argument is atomic proposition
    % states
    wi = args{1};
    z = getZ(args{1},h,N);
    z = z(k,:);
    for n = 1:N
        fNeg = [fNeg, sum(W{n}(wi,k))>=1+epsilon-bigM*(1-z(end,n))];
        fNeg = [fNeg, sum(W{n}(wi,k))<=1-epsilon+bigM*z(end,n)-1];
    end
end


% a binary variable for each agent
phi = getZ(formula,h,N);
phi = phi(k,:);
% negation constraint
fNeg = [fNeg, phi==ones(1,N)-z];