function [fFGI,phi] = getFGI(formula, args, k)

global W Wtotal Z ZLoop;

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

ZOr = [];
z = [];
fFGI = [];
for k = 1:h
    formulaOr = strcat('Or(', num2str(args{1}), ', (1-ZLoop))');
    zOr = getZ(formulaOr,k,0);
    ZOr = [ZOr; zOr];
    [fLTL,zLTL] = getLTL(args{1}, k);
    z = [z;zLTL];
    fFGI = [fFGI, fLTL];
    for n = 1:N  
        fFGI = [fFGI, ZOr(k,n)>=z(k,n), ZOr(k,n)>=1-ZLoop(k), ZOr(k,n)<=1-ZLoop(k)+z(k,n)];
    end
end

phi = binvar(1,N);
Z{length(Z)+1} = {phi,formula};

for n = 1:N
   fFGI = [fFGI, repmat(phi(n),h,1)<=ZOr(:,n), phi(n)>=1-h+sum(ZOr(:,n))];
end

    