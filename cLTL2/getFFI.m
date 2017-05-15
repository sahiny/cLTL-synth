function [fFF,phi] = getFFI(formula, args, k)

global W Wtotal Z;

if length(args)>1
    disp('GG takes a single argument');
    asset(length(args)==1);
end

% number of agents
N = length(W);
% number of states
I = size(W{1},1);
% time horizon
h = size(W{1},2)-1;

z = [];
fFF = [];
for k = 1:h
    for n = 1:N
        [fLTL,zLTL] = getLTL(args{1}, k);
        z = [z;zLTL];
        fFF = [fFF, fLTL];  
    end
end

phi = binvar(1,N);
Z{length(Z)+1} = {phi,formula};

for n = 1:N
   fFF = [fFF, repmat(phi(n),m,1)>=z(:,n), phi<=sum(z(:,n))];
end

    