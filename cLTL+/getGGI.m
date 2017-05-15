function [fGGI,phi] = getGGI(formula, args, k)

global W Wtotal Z zLoop ZLoop;

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
fGGI = [];
for k = 1:h
    [fLTL,zLTL] = getLTL(args{1}, k);
    z = [z;zLTL];
    fGGI = [fGGI, fLTL];  
end

phi = binvar(1,N);
Z{length(Z)+1} = {phi,formula};

for n = 1:N
   fGGI = [fGGI, repmat(phi(n),h,1)<=z(:,n), phi(n)>=1-h+sum(z(:,n))];
end

    